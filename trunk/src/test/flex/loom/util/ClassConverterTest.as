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
	import loom.abc.BaseMultiname;
	import loom.abc.InstanceInfo;
	import loom.abc.LNamespace;
	import loom.abc.Multiname;
	import loom.abc.QualifiedName;
	import loom.abc.enum.NamespaceKind;
	import loom.abc.AbcFile;
	import loom.reflection.ClassDefinition;
	import loom.reflection.Field;
	import loom.reflection.Method;
	
	import net.digitalprimates.fluint.tests.TestCase;

    /**
     * (Unfinished) Converts a ClassDefinition in to an AbcFile. The AbcFile can then be serialized to the ABC file format. 
     */
	public class ClassConverterTest extends TestCase
	{
        public function testSerialize() : void
        {
        	var PUBLIC : LNamespace = new LNamespace(NamespaceKind.NAMESPACE, "");
        	var VOID : BaseMultiname = new QualifiedName("void", PUBLIC);
        	var className : QualifiedName = new QualifiedName("FullClassDefinition", new LNamespace(NamespaceKind.NAMESPACE, "loom.template"));
        	var superClassName : QualifiedName = new QualifiedName("Object", PUBLIC);
        	var interfaceName : Multiname = new Multiname("Interface", null /* namespace set index - we wouldn't know this yet */);
        	var classDefinition : ClassDefinition = new ClassDefinition();
        	
        	// Create class definition
        	classDefinition.className = className;
        	classDefinition.superClass = superClassName;
        	classDefinition.addInterface(interfaceName);
        	
        	//TODO: Constructor
        	//TODO: Static initializer
        	
        	// Instance method
        	var instanceMethod : Method = classDefinition.addMethod(
        	   new QualifiedName("dynamicallyCreatedMethod", PUBLIC),
        	   VOID
        	);

            // Static method
        	var staticMethod : Method = classDefinition.addMethod(
        	   new QualifiedName("staticMethod", PUBLIC),
        	   VOID,
        	   true
        	);
        	
        	// Instance field
        	var instanceField : Field = classDefinition.addField(
        	   new QualifiedName("field", PUBLIC),
        	   new QualifiedName("String", PUBLIC)
        	);

            // Static field
            var staticField : Field = classDefinition.addField(
               new QualifiedName("STATIC_CONST", PUBLIC),
               new QualifiedName("String", PUBLIC),
               true
            );
            
            
            var converter : ClassConverter = new ClassConverter(classDefinition);
            var abcFile : AbcFile = converter.convert();
            
            // Check instance info characteristics
            assertEquals(1, abcFile.instanceInfo.length);
            var instanceInfo : InstanceInfo = abcFile.instanceInfo[0];
            assertTrue(instanceInfo.classMultiname.equals(className));
            assertEquals(1, instanceInfo.slotOrConstantTraits.length);
            assertEquals(1, instanceInfo.methodTraits.length);
            
            trace(abcFile);
        }		
	}
}