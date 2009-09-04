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
package loom.abc.enum
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import loom.abc.AbcFile;
	import loom.abc.BaseMultiname;
	import loom.abc.ClassInfo;
	import loom.abc.ExceptionInfo;
	import loom.abc.Integer;
	import loom.abc.Op;
	import loom.abc.S24Array;
	import loom.util.AbcSpec;
	import loom.util.ReadWritePair;
	
    /**
     * Loom representation of possible values for the kinds of opcodes in the ABC file format.
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "AVM2 instructions" in the AVM Spec (page 35)
     */
	//TODO: Implement output of opcode using ExceptionInfo pool for ops like newcatch
	//TODO: Derive local_count etc. from opcodes. Page 15 of the AVM2 spec covers this in more detail.
	public class Opcode
	{
		private static const _ALL_OPCODES : Dictionary = new Dictionary();
		
		// 158 total opcodes
        public static const add : Opcode = new Opcode(0xa0, "add");
        public static const astype : Opcode = new Opcode(0x86, "astype", [BaseMultiname, AbcSpec.U30]);
        public static const astypelate : Opcode = new Opcode(0x87, "astypelate");
        public static const bitand : Opcode = new Opcode(0xa8, "bitand");
        public static const bitnot : Opcode = new Opcode(0x97, "bitnot");
        public static const bitor : Opcode = new Opcode(0xa9, "bitor");
        public static const call : Opcode = new Opcode(0x41, "call", [int, AbcSpec.U30]);
        public static const callproperty : Opcode = new Opcode(0x46, "callproperty", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
        public static const callpropvoid : Opcode = new Opcode(0x4f, "callpropvoid", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
        public static const callsuper : Opcode = new Opcode(0x45, "callsuper", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
        public static const callsupervoid : Opcode = new Opcode(0x4e, "callsupervoid", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
        public static const checkfilter : Opcode = new Opcode(0x78, "checkfilter");
        public static const coerce : Opcode = new Opcode(0x80, "coerce", [BaseMultiname, AbcSpec.U30]);
        public static const coerce_a : Opcode = new Opcode(0x82, "coerce_a");
        public static const coerce_s : Opcode = new Opcode(0x85, "coerce_s");
        public static const construct : Opcode = new Opcode(0x42, "construct", [int, AbcSpec.U30]);
        public static const constructprop : Opcode = new Opcode(0x4a, "constructprop", [BaseMultiname, AbcSpec.U30], [int, AbcSpec.U30]);
        public static const constructsuper : Opcode = new Opcode(0x49, "constructsuper", [int, AbcSpec.U30]);
        public static const convert_b : Opcode = new Opcode(0x76, "convert_b");
        public static const convert_d : Opcode = new Opcode(0x75, "convert_d");
        public static const convert_i : Opcode = new Opcode(0x73, "convert_i");
        public static const convert_s : Opcode = new Opcode(0x70, "convert_s");
        public static const convert_u : Opcode = new Opcode(0x74, "convert_u");
        public static const decrement : Opcode = new Opcode(0x93, "decrement");
        public static const decrement_i : Opcode = new Opcode(0xc1, "decrement_i");
        public static const deleteproperty : Opcode = new Opcode(0x6a, "deleteproperty", [BaseMultiname, AbcSpec.U30]);
        public static const divide : Opcode = new Opcode(0xa3, "divide");
        public static const dup : Opcode = new Opcode(0x2a, "dup");
        public static const equals : Opcode = new Opcode(0xab, "equals");
        public static const findproperty : Opcode = new Opcode(0x5e, "findproperty", [BaseMultiname, AbcSpec.U30]);
        public static const findpropstrict : Opcode = new Opcode(0x5d, "findpropstrict", [BaseMultiname, AbcSpec.U30]);
        public static const getdescendants : Opcode = new Opcode(0x59, "getdescendants", [BaseMultiname, AbcSpec.U30]);
        public static const getglobalscope : Opcode = new Opcode(0x64, "getglobalscope");
        public static const getlex : Opcode = new Opcode(0x60, "getlex", [BaseMultiname, AbcSpec.U30]);
        public static const getlocal : Opcode = new Opcode(0x62, "getlocal", [int, AbcSpec.U30]);
        public static const getlocal_0 : Opcode = new Opcode(0xd0, "getlocal_0");
        public static const getlocal_1 : Opcode = new Opcode(0xd1, "getlocal_1");
        public static const getlocal_2 : Opcode = new Opcode(0xd2, "getlocal_2");
        public static const getlocal_3 : Opcode = new Opcode(0xd3, "getlocal_3");
        public static const getproperty : Opcode = new Opcode(0x66, "getproperty", [BaseMultiname, AbcSpec.U30]);
        public static const getscopeobject : Opcode = new Opcode(0x65, "getscopeobject", [int, AbcSpec.U8]); // unsigned byte - using U8 for the same reasons as pushbyte
        public static const getslot : Opcode = new Opcode(0x6c, "getslot", [int, AbcSpec.U30]);
        public static const getsuper : Opcode = new Opcode(0x04, "getsuper", [BaseMultiname, AbcSpec.U30]);
        public static const greaterequals : Opcode = new Opcode(0xb0, "greaterequals");
        public static const greaterthan : Opcode = new Opcode(0xaf, "greaterthan");
        public static const hasnext2 : Opcode = new Opcode(0x32, "hasnext2", [int, AbcSpec.U30], [int, AbcSpec.U30]); // I'm guessing this is two u30s since they are register positions - the spec was not explicit about this
        public static const ifeq : Opcode = new Opcode(0x13, "ifeq", [int, AbcSpec.S24]); 
        public static const iffalse : Opcode = new Opcode(0x12, "iffalse", [int, AbcSpec.S24]); 
        public static const ifge : Opcode = new Opcode(0x18, "ifge", [int, AbcSpec.S24]); 
        public static const ifgt : Opcode = new Opcode(0x17, "ifgt", [int, AbcSpec.S24]); 
        public static const ifle : Opcode = new Opcode(0x16, "ifle", [int, AbcSpec.S24]); 
        public static const iflt : Opcode = new Opcode(0x15, "iflt", [int, AbcSpec.S24]); 
        public static const ifne : Opcode = new Opcode(0x14, "ifne", [int, AbcSpec.S24]); 
        public static const ifnge : Opcode = new Opcode(0x0f, "ifnge", [int, AbcSpec.S24]); 
        public static const ifnle : Opcode = new Opcode(0x0d, "ifnle", [int, AbcSpec.S24]); 
        public static const ifnlt : Opcode = new Opcode(0x0c, "ifnlt", [int, AbcSpec.S24]); 
        public static const ifngt : Opcode = new Opcode(0x0e, "ifngt", [int, AbcSpec.S24]); 
        public static const ifstricteq : Opcode = new Opcode(0x19, "ifstricteq", [int, AbcSpec.S24]); 
        public static const ifstrictne : Opcode = new Opcode(0x1a, "ifstrictne", [int, AbcSpec.S24]); 
        public static const iftrue : Opcode = new Opcode(0x11, "iftrue", [int, AbcSpec.S24]); 
        public static const in_op : Opcode = new Opcode(0xb4, "in");
        public static const inclocal_i : Opcode = new Opcode(0xc2, "inclocal_i", [int, AbcSpec.U30]);
        public static const increment : Opcode = new Opcode(0x91, "increment");
        public static const increment_i : Opcode = new Opcode(0xc0, "increment_i");
        public static const initproperty : Opcode = new Opcode(0x68, "initproperty", [BaseMultiname, AbcSpec.U30]); 
        public static const istypelate : Opcode = new Opcode(0xb3, "istypelate");
        public static const jump : Opcode = new Opcode(0x10, "jump", [int, AbcSpec.S24]); 
        public static const kill : Opcode = new Opcode(0x08, "kill", [int, AbcSpec.U30]); 
        public static const label : Opcode = new Opcode(0x09, "label");
        public static const lessequals : Opcode = new Opcode(0xae, "lessequals");
        public static const lessthan : Opcode = new Opcode(0xad, "lessthan");
        public static const lookupswitch : Opcode = new Opcode(0x1b, "lookupswitch", [int, AbcSpec.S24], [int, AbcSpec.U30], [Array, AbcSpec.S24_ARRAY]);         // NOTE: lookupswitch is a special case because it has a variable number of arguments
        public static const lshift : Opcode = new Opcode(0xa5, "lshift");
        public static const modulo : Opcode = new Opcode(0xa4, "modulo");
        public static const multiply : Opcode = new Opcode(0xa2, "multiply");
        public static const negate : Opcode = new Opcode(0x90, "negate");
        public static const newactivation : Opcode = new Opcode(0x57, "newactivation");
        public static const newarray : Opcode = new Opcode(0x56, "newarray", [int, AbcSpec.U30]);
        public static const newcatch : Opcode = new Opcode(0x5a, "newcatch", [ExceptionInfo, AbcSpec.U30]);
        public static const newclass : Opcode = new Opcode(0x58, "newclass", [ClassInfo, AbcSpec.U30]);
        public static const newfunction : Opcode = new Opcode(0x40, "newfunction", [int, AbcSpec.U30]); // u30 - methodInfo
        public static const newobject : Opcode = new Opcode(0x55, "newobject", [int, AbcSpec.U30]);
        public static const nextname : Opcode = new Opcode(0x1e, "nextname");
        public static const nextvalue : Opcode = new Opcode(0x23, "nextvalue");
        public static const not : Opcode = new Opcode(0x96, "not");
        public static const pop : Opcode = new Opcode(0x29, "pop");
        public static const popscope : Opcode = new Opcode(0x1d, "popscope");
        public static const pushbyte : Opcode = new Opcode(0x24, "pushbyte", [int, AbcSpec.UNSIGNED_BYTE]); // unsigned byte... however, this was writing out too many bytes (4 bytes for the value instead of 1) 
        public static const pushdouble : Opcode = new Opcode(0x2f, "pushdouble", [Number, AbcSpec.U30]);
        public static const pushfalse : Opcode = new Opcode(0x27, "pushfalse");
        public static const pushint : Opcode = new Opcode(0x2d, "pushint", [Integer, AbcSpec.U30]);
        public static const pushnan : Opcode = new Opcode(0x28, "pushnan");
        public static const pushnull : Opcode = new Opcode(0x20, "pushnull");
        public static const pushscope : Opcode = new Opcode(0x30, "pushscope");
        public static const pushshort : Opcode = new Opcode(0x25, "pushshort", [int, AbcSpec.U30]);
        public static const pushstring : Opcode = new Opcode(0x2c, "pushstring", [String, AbcSpec.U30]);
        public static const pushtrue : Opcode = new Opcode(0x26, "pushtrue");
        public static const pushundefined : Opcode = new Opcode(0x21, "pushundefined");
        public static const pushwith : Opcode = new Opcode(0x1c, "pushwith");
        public static const returnvalue : Opcode = new Opcode(0x48, "returnvalue");
        public static const returnvoid : Opcode = new Opcode(0x47, "returnvoid");
        public static const rshift : Opcode = new Opcode(0xa6, "rshift");
        public static const setlocal : Opcode = new Opcode(0x63, "setlocal", [int, AbcSpec.U30]);
        public static const setlocal_0 : Opcode = new Opcode(0xD4, "setlocal_0");
        public static const setlocal_1 : Opcode = new Opcode(0xD5, "setlocal_1");
        public static const setlocal_2 : Opcode = new Opcode(0xD6, "setlocal_2");
        public static const setlocal_3 : Opcode = new Opcode(0xD7, "setlocal_3");
        public static const setproperty : Opcode = new Opcode(0x61, "setproperty", [BaseMultiname, AbcSpec.U30]);
        public static const setslot : Opcode = new Opcode(0x6d, "setslot", [int, AbcSpec.U30]); // u30 - slotId
        public static const setsuper : Opcode = new Opcode(0x05, "setsuper", [BaseMultiname, AbcSpec.U30]);
        public static const strictequals : Opcode = new Opcode(0xac, "strictequals");
        public static const subtract : Opcode = new Opcode(0xa1, "subtract");
        public static const swap : Opcode = new Opcode(0x2b, "swap");
        public static const throw_op : Opcode = new Opcode(0x03, "throw");
        public static const typeof_op : Opcode = new Opcode(0x95, "typeof");
        public static const urshift : Opcode = new Opcode(0xa7, "urshift");

        private var _opcodeName : String;
        private var _value : int;
        private var _argumentTypes : Array;

		public function Opcode(opcodeValue : int, opcodeName : String, ... typeAndReadWritePairs)
		{
			_value = opcodeValue;
			_opcodeName = opcodeName;
		    _argumentTypes = typeAndReadWritePairs;
		    
		    _ALL_OPCODES[_value] = this;
		}
		
		/**
		 * Serializes an array of Ops, returning a ByteArray with the opcode output block. 
		 */
		public static function serialize(ops : Array, abcFile : AbcFile) : ByteArray
		{
			var serializedOpcodes : ByteArray = AbcSpec.byteArray();
			for each (var op : Op in ops)
			{
				AbcSpec.writeU8(op.opcode._value, serializedOpcodes);
				
				var serializedArgumentCount : int = 0;
				for each (var typeAndReadWritePair : Array in op.opcode.argumentTypes)
				{
					var argumentType : * = typeAndReadWritePair[0];
					var readWritePair : ReadWritePair = typeAndReadWritePair[1];
					var rawValue : * = op.parameters[serializedArgumentCount++];
					
					var abcCompatibleValue : *;
					switch(argumentType)
					{
                        case int:
                            abcCompatibleValue = rawValue;
//                            trace("\tNumber: " + abcCompatibleValue + "(" + rawValue + ")");
                            break;

                        case Integer:
                            abcCompatibleValue = abcFile.constantPool.addInt(rawValue);
                            break;

                        case Number:
                            abcCompatibleValue = abcFile.constantPool.addDouble(rawValue);
//                            trace("\tNumber: " + abcCompatibleValue + "(" + rawValue + ")");
                            break;

                        case BaseMultiname:
                            abcCompatibleValue = abcFile.constantPool.addMultiname(rawValue);
//                            trace("\tMultiname: " + abcCompatibleValue + "(" + rawValue + ")");
                            break;

                        case ClassInfo:
                            abcCompatibleValue = abcFile.classInfo.indexOf(rawValue);
//                            trace("\tClassInfo: " + abcCompatibleValue + "(" + rawValue + ")");
                            break;

                        case String:
                            abcCompatibleValue = abcFile.constantPool.addString(rawValue);
//                            trace("\tString: " + abcCompatibleValue + "(" + rawValue + ")");
                            break;

                        case ExceptionInfo:
                            throw new Error("ExceptionInfo output is not yet implemented.");
                            break;
                        
                        default:
                            throw new Error("Unknown Opcode argument type.");
					}
					
                    try
                    {
					   readWritePair.write(abcCompatibleValue, serializedOpcodes);
                    }
                    catch (e : Error)
                    {
                    	trace(e);
                    }
				}
//				trace(serializedOpcodes.position + "\t" + op); 
			}
			
			serializedOpcodes.position = 0;
			return serializedOpcodes;
		}

		/**
		 * Parses the bytecode block out of the given ByteArray, returning an array of Ops representing the
		 * bytecode in the Ops. This method assumes that the ByteArray is positioned at the top of an
		 * opcode block. 
		 */
        public static function parse(byteArray : ByteArray, opcodeByteCount : int, abcFile : AbcFile) : Array
        {
        	var ops : Array = [];
        	
        	var positionAtEndOfBytecode : int = (byteArray.position + opcodeByteCount);
            while (byteArray.position != positionAtEndOfBytecode)
            {
                var opcode : Opcode = determineOpcode(AbcSpec.readU8(byteArray));
                
                var argumentValues : Array = [];
                for each (var argument : * in opcode.argumentTypes)
                {
                    var argumentType : * = argument[0];
                    var readWritePair : ReadWritePair = argument[1];
                    var byteCodeValue : * = readWritePair.read(byteArray); 
                    
                    switch (argumentType)
                    {
                        case int:
                            argumentValues.push(byteCodeValue);
                            break;

                        case Integer:
                            argumentValues.push(abcFile.constantPool.integerPool[byteCodeValue]);
                            break;

                        case Number:
                            argumentValues.push(abcFile.constantPool.doublePool[byteCodeValue]);
                            break;

                        case BaseMultiname:
                            argumentValues.push(abcFile.constantPool.multinamePool[byteCodeValue]);
                            break;

                        case ClassInfo:
                            argumentValues.push(abcFile.classInfo[byteCodeValue]);
                            break;

                        case String:
                            argumentValues.push(abcFile.constantPool.stringPool[byteCodeValue]);
                            break;

                        case Array:
                            //TODO: Come back and clean this up with a different parser model. lookupswitch f'd up the clean pre-existing model
                            // Special case for lookupswitch opcode. We need to iterate the possible case
                            // values and pull their offsets from the bytestream. The first value has
                            // already been read for us by the time this switch is invoked, we just need
                            // to pull the rest of the offsets. We determine how many there are by looking at
                            // the second argument to the op, which is the case_count
                            var caseOffsets : Array = [];
                            caseOffsets.push(byteCodeValue);
                            var caseCount : int = argumentValues[1];
                            for (var i : int = 0; i < caseCount; i++)
                            {
                            	caseOffsets.push(AbcSpec.readS24(byteArray));
                            }
                            argumentValues.push(caseOffsets);
                            break;

                        case ExceptionInfo:
                            //TODO: Currently ExceptionInfo objects are stored on the MethodInfo with which they are associated. Might
                            //      need to store them in a pool somewhere for lookup in these opcode I/O methods. For now we just
                            //      push an empty ExceptionInfo on to the argumemtvalues
                            argumentValues.push(new ExceptionInfo());
                            break;
                        
                        default:
                            throw new Error("Unknown Opcode argument type.");
                    }
                }
                
                var op : Op = opcode.op(argumentValues);
                ops.push(op);
//                trace(byteArray.position + "\t" + op);
            }
            
            return ops;
        }
		
		public static function determineOpcode(opcodeByte : int) : Opcode
		{
			var matchingOpcode : Opcode = _ALL_OPCODES[opcodeByte];
			
			if (!matchingOpcode)
			{
				throw new Error("No match for Opcode: 0x" + opcodeByte.toString(16) + " (" + opcodeByte + ")");
			}
			
			return matchingOpcode;
		}
		
		public function get argumentTypes() : Array
		{
			return _argumentTypes;
		}
		
		public function get opcodeName() : String
		{
			return _opcodeName;
		}
		
		public function op(opArguments : Array = null) : Op
		{
			if (opArguments == null)
			{
				opArguments = [];
			}
			
			if (opArguments.length != this._argumentTypes.length)
			{
				throw new Error(this.opcodeName  + " requires " + this._argumentTypes.length + " arguments.");
			}
			
            for (var argIndex : int = 0; argIndex < opArguments.length; argIndex++)
            {
            	var argument : * = opArguments[argIndex];
            	var expectedArgumentType : Class = this._argumentTypes[argIndex][0];
//            	if (!(argument is expectedArgumentType))
//            	{
//            		throw new Error(argument + " is not an instance of " + expectedArgumentType);
//            	}
            }
            
            return new Op(this, opArguments);
		}
	}
}

//public static const OP_bkpt:int = 0x01
//public static const OP_nop:int = 0x02
//public static const OP_throw:int = 0x03
//public static const OP_getsuper:int = 0x04
//public static const OP_setsuper:int = 0x05
//public static const OP_dxns:int = 0x06
//public static const OP_dxnslate:int = 0x07
//public static const OP_kill:int = 0x08
//public static const OP_label:int = 0x09
//public static const OP_ifnlt:int = 0x0C
//public static const OP_ifnle:int = 0x0D
//public static const OP_ifngt:int = 0x0E
//public static const OP_ifnge:int = 0x0F
//public static const OP_jump:int = 0x10
//public static const OP_iftrue:int = 0x11
//public static const OP_iffalse:int = 0x12
//public static const OP_ifeq:int = 0x13
//public static const OP_ifne:int = 0x14
//public static const OP_iflt:int = 0x15
//public static const OP_ifle:int = 0x16
//public static const OP_ifgt:int = 0x17
//public static const OP_ifge:int = 0x18
//public static const OP_ifstricteq:int = 0x19
//public static const OP_ifstrictne:int = 0x1A
//public static const OP_lookupswitch:int = 0x1B
//public static const OP_pushwith:int = 0x1C
//public static const OP_popscope:int = 0x1D
//public static const OP_nextname:int = 0x1E
//public static const OP_hasnext:int = 0x1F
//public static const OP_pushnull:int = 0x20
//public static const OP_pushundefined:int = 0x21
//public static const OP_pushconstant:int = 0x22
//public static const OP_nextvalue:int = 0x23
//public static const OP_pushbyte:int = 0x24
//public static const OP_pushshort:int = 0x25
//public static const OP_pushtrue:int = 0x26
//public static const OP_pushfalse:int = 0x27
//public static const OP_pushnan:int = 0x28
//public static const OP_pop:int = 0x29
//public static const OP_dup:int = 0x2A
//public static const OP_swap:int = 0x2B
//public static const OP_pushstring:int = 0x2C
//public static const OP_pushint:int = 0x2D
//public static const OP_pushuint:int = 0x2E
//public static const OP_pushdouble:int = 0x2F
//public static const OP_pushscope:int = 0x30
//public static const OP_pushnamespace:int = 0x31
//public static const OP_hasnext2:int = 0x32
//public static const OP_newfunction:int = 0x40
//public static const OP_call:int = 0x41
//public static const OP_construct:int = 0x42
//public static const OP_callmethod:int = 0x43
//public static const OP_callstatic:int = 0x44
//public static const OP_callsuper:int = 0x45
//public static const OP_callproperty:int = 0x46
//public static const OP_returnvoid:int = 0x47
//public static const OP_returnvalue:int = 0x48
//public static const OP_constructsuper:int = 0x49
//public static const OP_constructprop:int = 0x4A
//public static const OP_callsuperid:int = 0x4B
//public static const OP_callproplex:int = 0x4C
//public static const OP_callinterface:int = 0x4D
//public static const OP_callsupervoid:int = 0x4E
//public static const OP_callpropvoid:int = 0x4F
//public static const OP_applytype:int = 0x53
//public static const OP_newobject:int = 0x55
//public static const OP_newarray:int = 0x56
//public static const OP_newactivation:int = 0x57
//public static const OP_newclass:int = 0x58
//public static const OP_getdescendants:int = 0x59
//public static const OP_newcatch:int = 0x5A
//public static const OP_findpropstrict:int = 0x5D
//public static const OP_findproperty:int = 0x5E
//public static const OP_finddef:int = 0x5F
//public static const OP_getlex:int = 0x60
//public static const OP_setproperty:int = 0x61
//public static const OP_getlocal:int = 0x62
//public static const OP_setlocal:int = 0x63
//public static const OP_getglobalscope:int = 0x64
//public static const OP_getscopeobject:int = 0x65
//public static const OP_getproperty:int = 0x66
//public static const OP_getouterscope:int = 0x67
//public static const OP_initproperty:int = 0x68
//public static const OP_setpropertylate:int = 0x69
//public static const OP_deleteproperty:int = 0x6A
//public static const OP_deletepropertylate:int = 0x6B
//public static const OP_getslot:int = 0x6C
//public static const OP_setslot:int = 0x6D
//public static const OP_getglobalslot:int = 0x6E
//public static const OP_setglobalslot:int = 0x6F
//public static const OP_convert_s:int = 0x70
//public static const OP_esc_xelem:int = 0x71
//public static const OP_esc_xattr:int = 0x72
//public static const OP_convert_i:int = 0x73
//public static const OP_convert_u:int = 0x74
//public static const OP_convert_d:int = 0x75
//public static const OP_convert_b:int = 0x76
//public static const OP_convert_o:int = 0x77
//public static const OP_coerce:int = 0x80
//public static const OP_coerce_b:int = 0x81
//public static const OP_coerce_a:int = 0x82
//public static const OP_coerce_i:int = 0x83
//public static const OP_coerce_d:int = 0x84
//public static const OP_coerce_s:int = 0x85
//public static const OP_astype:int = 0x86
//public static const OP_astypelate:int = 0x87
//public static const OP_coerce_u:int = 0x88
//public static const OP_coerce_o:int = 0x89
//public static const OP_negate:int = 0x90
//public static const OP_increment:int = 0x91
//public static const OP_inclocal:int = 0x92
//public static const OP_decrement:int = 0x93
//public static const OP_declocal:int = 0x94
//public static const OP_typeof:int = 0x95
//public static const OP_not:int = 0x96
//public static const OP_bitnot:int = 0x97
//public static const OP_concat:int = 0x9A
//public static const OP_add_d:int = 0x9B
//public static const OP_add:int = 0xA0
//public static const OP_subtract:int = 0xA1
//public static const OP_multiply:int = 0xA2
//public static const OP_divide:int = 0xA3
//public static const OP_modulo:int = 0xA4
//public static const OP_lshift:int = 0xA5
//public static const OP_rshift:int = 0xA6
//public static const OP_urshift:int = 0xA7
//public static const OP_bitand:int = 0xA8
//public static const OP_bitor:int = 0xA9
//public static const OP_bitxor:int = 0xAA
//public static const OP_equals:int = 0xAB
//public static const OP_strictequals:int = 0xAC
//public static const OP_lessthan:int = 0xAD
//public static const OP_lessequals:int = 0xAE
//public static const OP_greaterthan:int = 0xAF
//public static const OP_greaterequals:int = 0xB0
//public static const OP_instanceof:int = 0xB1
//public static const OP_istype:int = 0xB2
//public static const OP_istypelate:int = 0xB3
//public static const OP_in:int = 0xB4
//public static const OP_increment_i:int = 0xC0
//public static const OP_decrement_i:int = 0xC1
//public static const OP_inclocal_i:int = 0xC2
//public static const OP_declocal_i:int = 0xC3
//public static const OP_negate_i:int = 0xC4
//public static const OP_add_i:int = 0xC5
//public static const OP_subtract_i:int = 0xC6
//public static const OP_multiply_i:int = 0xC7
//public static const OP_getlocal0:int = 0xD0
//public static const OP_getlocal1:int = 0xD1
//public static const OP_getlocal2:int = 0xD2
//public static const OP_getlocal3:int = 0xD3
//public static const OP_setlocal0:int = 0xD4
//public static const OP_setlocal1:int = 0xD5
//public static const OP_setlocal2:int = 0xD6
//public static const OP_setlocal3:int = 0xD7
//public static const OP_debug:int = 0xEF
//public static const OP_debugline:int = 0xF0
//public static const OP_debugfile:int = 0xF1
//public static const OP_bkptline:int = 0xF2