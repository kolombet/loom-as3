/**
* Copyright 2009 Maxim Cassian Porges
* 
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
* 
*     http://www.apache.org/licenses/LICENSE-2.0
* 
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package loom.util
{
	import flash.utils.ByteArray;
	
	import loom.abc.AbcFile;
	import loom.abc.BaseMultiname;
	import loom.abc.ClassInfo;
	import loom.abc.ClassTrait;
	import loom.abc.ConstantPool;
	import loom.abc.ExceptionInfo;
	import loom.abc.FunctionTrait;
	import loom.abc.InstanceInfo;
	import loom.abc.LNamespace;
	import loom.abc.MethodBody;
	import loom.abc.MethodInfo;
	import loom.abc.MethodTrait;
	import loom.abc.Multiname;
	import loom.abc.MultinameL;
	import loom.abc.NamespaceSet;
	import loom.abc.QualifiedName;
	import loom.abc.RuntimeQualifiedName;
	import loom.abc.RuntimeQualifiedNameL;
	import loom.abc.ScriptInfo;
	import loom.abc.SlotOrConstantTrait;
	import loom.abc.TraitInfo;
	import loom.abc.enum.ClassConstant;
	import loom.abc.enum.ConstantKind;
	import loom.abc.enum.MethodFlag;
	import loom.abc.enum.MultinameKind;
	import loom.abc.enum.NamespaceKind;
	import loom.abc.enum.Opcode;
	import loom.abc.enum.TraitAttributes;
	import loom.abc.enum.TraitKind;
	import loom.reflection.Argument;
	import loom.reflection.Metadata;
	
	/**
	 * Takes an ABC bytecode block as a stream of bytes and converts it in to a Loom representation of the ABC file format. This
	 * class is the symmetric opposite of <code>AbcSerializer</code>.
	 * 
	 * <p>
	 * Bytecode can be loaded either from the file system or a SWF file and handed to this object for deserialization.
	 * </p>
	 * 
	 * @see    AbcSerializer
	 */
	//TODO: Capture ranges for bytecode blocks so they can be checked in unit tests
	public class AbcDeserializer
	{
		private var _byteStream : ByteArray;
		
		public function AbcDeserializer(byteStream : ByteArray)
		{
			_byteStream = byteStream;
		}
		
		/**
		 * Acts as a guard to make sure that the expected number of items was extracted from the
		 * ABC file.
		 */
		private function assertExtraction(expectedCount : int, elementCollection : Array, collectionName : String) : void
		{
			if (expectedCount == 0)
			{
				// the spec says: "Each of the count entries (for example, int_count) must be one more than
				// the number of entries in the corresponding array, and the first entry in the array is element “1”."
				// this is a lie. If the count is 0, then there are no entries in the pool in this ABC file.
			}
			else
			{
				var collectionLength : int = elementCollection.length;
				if (expectedCount != collectionLength)
				{
					throw new Error(
					    StringUtil.substitute(
					        "Expected {0} elements in {1}, actual count is {2}",
					        expectedCount,
					        collectionName,
					        collectionLength
					    )
	                ); 
				}
			}
		}
		
		public function deserializeConstantPool(pool : ConstantPool) : ConstantPool
		{
			extract(_byteStream, pool.integerPool, readS32);
            extract(_byteStream, pool.uintPool, readU32);
            extract(_byteStream, pool.doublePool, readD64);
            extract(_byteStream, pool.stringPool, readStringInfo);
            
            // extract namespaces
            extract(
                _byteStream,
                pool.namespacePool,
                function() : LNamespace
                {
                    return new LNamespace(
                        NamespaceKind.determineKind(readU8()),
                        pool.stringPool[readU30()]
                    );
                }
            );
            
            // extract namespace sets
            extract(
                _byteStream,
                pool.namespaceSetPool,
                function() : NamespaceSet
                {
                    var namespaceIndexRefCount : int = readU30();
                    var namespaceArray : Array = [];
                    for (var nssetNamespaceIndex : int = 0; nssetNamespaceIndex < namespaceIndexRefCount; nssetNamespaceIndex++)
                    {
                        namespaceArray.push(pool.namespacePool[readU30()]);
                    }
                    return new NamespaceSet(namespaceArray);
                }
            );
            
            // extract multinames
            extract(
                _byteStream,
                pool.multinamePool,
                function() : BaseMultiname
                {
                    var multiname : BaseMultiname = null;
                    
                    var kind : MultinameKind = MultinameKind.determineKind(readU8());
                    switch(kind)
                    {
                        case MultinameKind.QNAME:
                        case MultinameKind.QNAME_A:
                            // multiname_kind_QName 
                            // { 
                            //  u30 ns 
                            //  u30 name 
                            // }
                            var nameSpace : LNamespace = pool.namespacePool[readU30()];
                            multiname = new QualifiedName(
                               pool.stringPool[readU30()],
                               nameSpace,
                               kind
                            );
                            break;
    
                        case MultinameKind.MULTINAME:
                        case MultinameKind.MULTINAME_A:
                            // multiname_kind_Multiname 
                            // { 
                            //  u30 name 
                            //  u30 ns_set 
                            // }
                            multiname = new Multiname(
                                pool.stringPool[readU30()],
                                pool.namespaceSetPool[readU30()],
                                kind
                            );
                            break;
    
                        case MultinameKind.MULTINAME_L:
                        case MultinameKind.MULTINAME_LA:
                            // multiname_kind_MultinameL 
                            // { 
                            //  u30 ns_set 
                            // }
                            multiname = new MultinameL(
                                pool.namespaceSetPool[readU30()],
                                kind
                            );
                            break;
    
                        case MultinameKind.RTQNAME:
                        case MultinameKind.RTQNAME_A:
                            // multiname_kind_RTQName 
                            // { 
                            //  u30 name 
                            // }
                            multiname = new RuntimeQualifiedName(
                               pool.stringPool[readU30()],
                               kind
                            );
                            break;
    
                        case MultinameKind.RTQNAME_L:
                        case MultinameKind.RTQNAME_LA:
                            // multiname_kind_RTQNameL 
                            // { 
                            // }
                            multiname = new RuntimeQualifiedNameL(kind);
                            break;
                    }
                 
                    return multiname;
                }
            );
            
            return pool;
		}
		
        /**
         * Takes the ABC block handed to the constructor and deserializes it.
         * 
         * @return  The <code>AbcFile</code> represented by the bytecode block given to the constructor.
         */
		public function deserialize(positionInByteArrayToReadFrom : int = 0) : AbcFile
		{
			_byteStream.position = positionInByteArrayToReadFrom;
			var abcFile : AbcFile = new AbcFile();
			var pool : ConstantPool = abcFile.constantPool;
			
			var startTime : Number = new Date().getTime();
			
			abcFile.minorVersion = readU16();
			abcFile.majorVersion = readU16();
			
			deserializeConstantPool(pool);
            
//            trace("MethodInfos: " + _byteStream.position);
            var methodCount : int = readU30();
            for (var methodIndex : int = 0; methodIndex < methodCount; methodIndex++)
            {
                // method_info 
                // { 
                //  u30 param_count 
                //  u30 return_type 
                //  u30 param_type[param_count] 
                //  u30 name 
                //  u8  flags 
                //  option_info options 
                //  param_info param_names 
                // }
            	var methodInfo : MethodInfo = new MethodInfo();
                var paramCount : int = readU30();
                methodInfo.returnType = pool.multinamePool[readU30()];
                for (var argumentIndex : int = 0; argumentIndex < paramCount; argumentIndex++)
                {
                    methodInfo.argumentCollection.push(new Argument(pool.multinamePool[readU30()]));
                }
                methodInfo.methodName = pool.stringPool[readU30()];
                methodInfo.flags = readU8();
                if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_OPTIONAL))
                {
					// option_info  
					// { 
					//  u30 option_count 
					//  option_detail option[option_count] 
					// }
					// option_detail 
					// { 
					//  u30 val 
					//  u8  kind 
					// }
					var optionInfoCount : int = readU30();
					for (var optionInfoIndex : int = 0; optionInfoIndex < optionInfoCount; optionInfoIndex++)
					{
						var valueIndexInConstantPool : int = readU30();
						var optionalValueKind : int = readU8();
						var defaultValue : Object = null;
						switch (optionalValueKind)
						{
							case ConstantKind.INT.value:
                                defaultValue = pool.integerPool[valueIndexInConstantPool];
                                break;
							
							case ConstantKind.UINT.value:
                                defaultValue = pool.uintPool[valueIndexInConstantPool];
                                break;
                                
							case ConstantKind.DOUBLE.value:
                                defaultValue = pool.doublePool[valueIndexInConstantPool];
                                break;
                                
							case ConstantKind.UTF8.value:
                                defaultValue = pool.stringPool[valueIndexInConstantPool];
                                break;

							case ConstantKind.TRUE.value:
                                defaultValue = true;
                                break;

							case ConstantKind.FALSE.value:
                                defaultValue = false;
                                break;

							case ConstantKind.NULL.value:
                                defaultValue = null;
                                break;
							
							case ConstantKind.UNDEFINED.value:
                                defaultValue = undefined;
                                break;
							
							case ConstantKind.NAMESPACE.value:
							case ConstantKind.PACKAGE_NAMESPACE.value:
							case ConstantKind.PACKAGE_INTERNAL_NAMESPACE.value:
							case ConstantKind.PROTECTED_NAMESPACE.value:
							case ConstantKind.EXPLICIT_NAMESPACE.value:
							case ConstantKind.STATIC_PROTECTED_NAMESPACE.value:
							case ConstantKind.PRIVATE_NAMESPACE.value:
                                defaultValue = pool.namespacePool[valueIndexInConstantPool];
                                break;

                            default:
                                throw new Error("Unknown optional value kind: " + optionalValueKind);
                                break;
						}
						var qualifiedName : QualifiedName = new QualifiedName("~~ need constants ~~", null, MultinameKind.QNAME);
                        methodInfo.optionalParameters.push(new Argument(qualifiedName, true, defaultValue, ConstantKind.determineKind(optionalValueKind)));
					}
                }

                if (MethodFlag.flagPresent(methodInfo.flags, MethodFlag.HAS_PARAM_NAMES))
                {
                	//TODO: parse param names
                    // param_info  
                    // { 
                    //  u30 param_name[param_count] -- index in to String Pool 
                    // }
                	throw new Error("Has Param Names");
                }
                
                abcFile.addMethodInfo(methodInfo);
            }
            
//            trace("Metadata: " + _byteStream.position);
            var metadataCount : int = readU30();
            for (var metadataIndex : int = 0; metadataIndex < metadataCount; metadataIndex++)
            {
                // metadata_info  
                // { 
                //  u30 name 
                //  u30 item_count 
                //  item_info items[item_count] 
                // }
                // item_info  
                // { 
                //  u30 key 
                //  u30 value 
                // }
                // The above is a lie... the metadata is saved with all the keys first, then all the values afterwards.
                // So, if the item_count is 3, that means you will get three keys followed by three values. The keys
                // and values match up with each other in index, so the first key matches the first value, second key
                // matches the second value, etc.
                var metadataInstance : Metadata = new Metadata();
                metadataInstance.name = pool.stringPool[readU30()];
                abcFile.addMetadataInfo(metadataInstance);
                var keyValuePairCount : int = readU30();
                var keys : Array = [];
                
                // Suck out the keys first
                for (var keyIndex : int = 0; keyIndex < keyValuePairCount; keyIndex++)
                {
                	var key : String = pool.stringPool[readU30()];
                	keys.push(key);
                }

                // Map keys to values in another loop
                for each (var currentKey : String in keys)
                {
                	// Note that if a key is zero, then this is a keyless entry and only carries a value (AVM2 overview, page 27 under 4.6 metadata_info) 
                	var value : String = pool.stringPool[readU30()];
                	metadataInstance.properties[currentKey] = value;
                }
            }
            
//            trace("Classes: " + _byteStream.position);
            var classCount : int = readU30();
            for (var instanceIndex : int = 0; instanceIndex < classCount; instanceIndex++)
            {
	            // instance_info  
	            // { 
	            //  u30 name 
	            //  u30 super_name 
	            //  u8  flags 
	            //  u30 protectedNs  
	            //  u30 intrf_count 
	            //  u30 interface[intrf_count] 
	            //  u30 iinit 
	            //  u30 trait_count 
	            //  traits_info trait[trait_count] 
	            // }
//	            trace("InstanceInfo: " + _byteStream.position);
            	var instanceInfo : InstanceInfo = new InstanceInfo();
            	
                // The AVM2 spec dictates that this should always be a QualifiedName, but when parsing SWFs I have come across
                // Multinames with single namespaces (which are essentially QualifiedNames - the only reason to be a multiname
                // is to have multiple namespaces to search within to resolve a name). I haven't heard back from the Tamarin
                // list yet on this anomaly so I'm going to convert single-namespace Multinames to QualifiedNames here.
                //
                // From the spec (Section 4.7 "Instance", page 28):
                //  name 
                //      The name field is an index into the multiname array of the constant pool; it provides a name for the 
                //      class. The entry specified must be a QName. 
            	var classMultiname : BaseMultiname = pool.multinamePool[readU30()];
            	
            	instanceInfo.classMultiname = convertToQualifiedName(classMultiname);
            	instanceInfo.superclassMultiname = pool.multinamePool[readU30()]; 
	            var instanceInfoFlags : int = readU8();
	            instanceInfo.isFinal = ClassConstant.FINAL.present(instanceInfoFlags);
	            instanceInfo.isInterface = ClassConstant.INTERFACE.present(instanceInfoFlags);
	            instanceInfo.isProtected = ClassConstant.PROTECTED_NAMESPACE.present(instanceInfoFlags);
	            instanceInfo.isSealed = ClassConstant.SEALED.present(instanceInfoFlags);
	            if (instanceInfo.isProtected)
	            {
	                instanceInfo.protectedNamespace = pool.namespacePool[readU30()];
	            }
	            var interfaceCount : int = readU30();
	            for (var interfaceIndex : int = 0; interfaceIndex < interfaceCount; interfaceIndex++)
	            {
	            	instanceInfo.interfaceMultinames.push(pool.multinamePool[readU30()]);
	            }
	            instanceInfo.instanceInitializer = abcFile.methodInfo[readU30()];
	            instanceInfo.instanceInitializer.loomName = "constructor";
	            instanceInfo.traits = deserializeTraitsInfo(abcFile, _byteStream);
	            abcFile.addInstanceInfo(instanceInfo);
            }
	            
	        // class info
//	        trace("ClassInfo: " + _byteStream.position);
            for (var classIndex : int = 0; classIndex < classCount; classIndex++)
            {
	            // class_info  
	            // { 
	            //  u30 cinit 
	            //  u30 trait_count 
	            //  traits_info traits[trait_count] 
	            // }
	            var classInfo : ClassInfo = new ClassInfo();
	            classInfo.staticInitializer = abcFile.methodInfo[readU30()];
	            classInfo.staticInitializer.loomName = "staticInitializer";
                classInfo.traits = deserializeTraitsInfo(abcFile, _byteStream);
                abcFile.addClassInfo(classInfo);
            }
            
            trace("ClassInfos parsed by " + (new Date().getTime() - startTime) + " ms");
            
            // script_info  
            // { 
            //  u30 init 
            //  u30 trait_count 
            //  traits_info trait[trait_count] 
            // }
//            trace("Scripts: " + _byteStream.position);
            var scriptCount : int = readU30();
            for (var scriptIndex : int = 0; scriptIndex < scriptCount; scriptIndex++)
            {
            	var scriptInfo : ScriptInfo = new ScriptInfo();
            	scriptInfo.scriptInitializer = abcFile.methodInfo[readU30()];
            	scriptInfo.scriptInitializer.loomName = "scriptInitializer";
	            scriptInfo.traits = deserializeTraitsInfo(abcFile, _byteStream);
	            abcFile.addScriptInfo(scriptInfo);
            }
            
            trace("ScriptInfos parsed by " + (new Date().getTime() - startTime) + " ms");
            
//            trace("MethodBodies: " + _byteStream.position);
            var methodBodyCount : int = readU30();
            for (var bodyIndex : int = 0; bodyIndex < methodBodyCount; bodyIndex++)
            {
            	var methodBody : MethodBody = new MethodBody();
	            // method_body_info 
	            // { 
	            //  u30 method 
	            //  u30 max_stack 
	            //  u30 local_count 
	            //  u30 init_scope_depth  
	            //  u30 max_scope_depth 
	            //  u30 code_length 
	            //  u8  code[code_length] 
	            //  u30 exception_count 
	            //  exception_info exception[exception_count] 
	            //  u30 trait_count 
	            //  traits_info trait[trait_count] 
                // }
                methodBody.methodSignature = abcFile.methodInfo[readU30()];
                methodBody.maxStack = readU30();
                methodBody.localCount = readU30();
                methodBody.initScopeDepth = readU30();
                methodBody.maxScopeDepth = readU30();
	            
	            var codeLength : int = readU30();
                //TODO: Not parsing opcodes by skipping ahead halves the parsing time for SWFLoader tests... might be a useful optimization flag
                var parseOpcodes : Boolean = true; 
                if (parseOpcodes)
                {
                	methodBody.opcodes = Opcode.parse(_byteStream, codeLength, abcFile);
//                    trace("\t" + methodBody.opcodes.join("\n\t"));
                }
                else
                {
//		            for (var codeIndex : int = 0; codeIndex < codeLength; codeIndex++)
//		            {
//		            	methodBody.opcodes.push(readU8());
//		            }
	                _byteStream.position += codeLength;
                }
                	            	            
	            var exceptionCount : int = readU30();
                for (var exceptionIndex : int = 0; exceptionIndex < exceptionCount; exceptionIndex++)
                {
                	var exceptionInfo : ExceptionInfo = new ExceptionInfo();
                    // exception_info  
                    // { 
                    //  u30 from 
                    //  u30 to  
                    //  u30 target 
                    //  u30 exc_type 
                    //  u30 var_name 
                    // }
                    exceptionInfo.exceptionEnabledFromCodePosition = readU30();
                    exceptionInfo.exceptionEnabledToCodePosition = readU30();
                    exceptionInfo.codePositionToJumpToOnException = readU30();
                    exceptionInfo.exceptionTypeName = pool.stringPool[readU30()];
                    exceptionInfo.nameOfVariableReceivingException = pool.stringPool[readU30()];
                    methodBody.exceptionInfos.push(exceptionInfo);
                }

                methodBody.traits = deserializeTraitsInfo(abcFile, _byteStream);
                methodBody.methodSignature.methodBody = methodBody;
                
                abcFile.addMethodBody(methodBody);
            }
            
            trace("MethodInfos parsed by " + (new Date().getTime() - startTime) + " ms");
            
            return abcFile;
		}
		
		public function convertToQualifiedName(classMultiname : BaseMultiname) : QualifiedName
		{
			if (classMultiname is QualifiedName)
			{
				return classMultiname as QualifiedName;
			}
			
			var qualifiedName : QualifiedName = null;
            if (classMultiname is Multiname)
            {
                // A QualifiedName can only have one namespace, so we ensure that this is the case
                // before attempting conversion
                var classMultinameAsMultiname : Multiname = classMultiname as Multiname;
                if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1)
                {
                    qualifiedName = new QualifiedName(classMultinameAsMultiname.name, classMultinameAsMultiname.namespaceSet.namespaces[0]);
                }
                else
                {
                    trace("Multiname " + classMultiname + " has more than 1 namespace in its namespace set - unable to convert to QualifiedName.");
                }
            }
            
            return qualifiedName;
		}

        public function deserializeTraitsInfo(abcFile : AbcFile, byteStream : ByteArray) : Array
        {
        	var traits : Array = [];
        	var pool : ConstantPool = abcFile.constantPool;
        	var methodInfos : Array = abcFile.methodInfo;
        	var metadata : Array = abcFile.metadataInfo;
        	
        	var traitCount : int = readU30();
            for (var traitIndex : int = 0; traitIndex < traitCount; traitIndex++)
            {
            	var trait : TraitInfo;
                // traits_info  
                // { 
                //  u30 name 
                //  u8  kind 
                //  u8  data[] 
                //  u30 metadata_count 
                //  u30 metadata[metadata_count] 
                // }
                var traitName : BaseMultiname = pool.multinamePool[readU30()];
                var traitMultiname : QualifiedName = convertToQualifiedName(traitName);
                var traitKindValue : int = readU8();
                var traitKind : TraitKind = TraitKind.determineKind(traitKindValue);
                switch(traitKind)
                {
                    case TraitKind.SLOT:
                    case TraitKind.CONST:
                        // trait_slot 
                        // { 
                        //  u30 slot_id 
                        //  u30 type_name 
                        //  u30 vindex 
                        //  u8  vkind  
                        // }
                        var slotOrConstantTrait : SlotOrConstantTrait = new SlotOrConstantTrait();
                        slotOrConstantTrait.slotId = readU30();
                        slotOrConstantTrait.typeMultiname = pool.multinamePool[readU30()];
                        slotOrConstantTrait.vindex = readU30();
                        if (slotOrConstantTrait.vindex != 0)
                        {
                        	slotOrConstantTrait.vkind = ConstantKind.determineKind(readU8());
                        }
                        trait = slotOrConstantTrait;
                        break;

                    case TraitKind.METHOD:
                    case TraitKind.GETTER:
                    case TraitKind.SETTER:
                        // trait_method 
                        // { 
                        //  u30 disp_id 
                        //  u30 method 
                        // }
                        var methodTrait : MethodTrait = new MethodTrait();
                        methodTrait.dispositionId = readU30();
                        
                        // It's not strictly necessary to do this, but it helps the API for the MethodInfo to have a
                        // reference to its traits and vice versa 
                        var associatedMethodInfo : MethodInfo = methodInfos[readU30()]
                        methodTrait.traitMethod = associatedMethodInfo;
                        associatedMethodInfo.loomAssignedMethodTrait = methodTrait;
                        methodTrait.traitMethod.loomName = traitMultiname;
                        
                        trait = methodTrait;
                        break;

                    case TraitKind.CLASS:
                        // trait_class 
                        // { 
                        //  u30 slot_id 
                        //  u30 classi 
                        // }
                        var classTrait : ClassTrait = new ClassTrait();
                        classTrait.classSlotId = readU30();
                        classTrait.classIndex = readU30();
                        trait = classTrait;
                        break;

                    case TraitKind.FUNCTION:
                        // trait_function 
                        // { 
                        //  u30 slot_id 
                        //  u30 function 
                        // } 
                        var functionTrait : FunctionTrait = new FunctionTrait();
                        functionTrait.functionSlotId = readU30();
                        functionTrait.functionMethod = methodInfos[readU30()];
                        trait = functionTrait;
                        break;
                }
                
                // (as listed at the top of this switch statement)
                // traits_info
                // {
                //  ...
                //  u30 metadata_count 
                //  u30 metadata[metadata_count]
                // }
                // AVM2 overview, page 29
                // "These fields are present only if ATTR_Metadata is present in the upper four bits of the kind field. 
                // The value of the metadata_count field is the number of entries in the metadata array. That array 
                // contains indices into the metadata array of the abcFile." 
                if (traitKindValue & (TraitAttributes.METADATA.bitMask << 4))
                {
                	var numberOfTraitMetadataItems : int = readU30();
                	for (var traitMetadataIndex : int = 0; traitMetadataIndex < numberOfTraitMetadataItems; traitMetadataIndex++)
                	{
                		trait.addMetadata(metadata[readU30()]);
                	}
                }
                
                trait.traitMultiname = traitMultiname;
                trait.isFinal = Boolean((traitKindValue >> 4) & TraitAttributes.FINAL.bitMask);
                trait.isOverride = Boolean((traitKindValue >> 4) & TraitAttributes.OVERRIDE.bitMask);
                trait.traitKind = traitKind;
                traits.push(trait);
            }
            
            return traits;
        }

        public function extract(byteStream : ByteArray, pool : Array, extractionMethod : Function) : void
        {
            var itemCount : int = readU30();
            for (var itemIndex : int = 1; itemIndex < itemCount; itemIndex++)
            {
            	var result : * = extractionMethod.apply(this);
                pool.push(result);
            }
            assertExtraction(itemCount, pool, "");
        }

        public function readU16() : int
        {
            return AbcSpec.readU16(_byteStream);
        }

        public function readU30() : int
        {
            return AbcSpec.readU30(_byteStream);
        }

        public function readU32() : int
        {
            return AbcSpec.readU32(_byteStream);
        }

        public function readD64() : Number
        {
            return AbcSpec.readD64(_byteStream);
        }

        public function readS32() : int
        {
            return AbcSpec.readS32(_byteStream);
        }

        public function readU8() : int
        {
            return AbcSpec.readU8(_byteStream);
        }

        public function readStringInfo() : String
        {
            return AbcSpec.readStringInfo(_byteStream);
        }
	}
}