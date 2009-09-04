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
package loom
{		
	import loom.abc.ConstantPoolTest;
	import loom.abc.LNamespaceTest;
	import loom.abc.NamespaceSetTest;
	import loom.abc.enum.OpcodeTest;
	import loom.assets.abc.FCDSubClassTest;
	import loom.swf.AbcClassLoaderTest;
	import loom.swf.SwfTest;
	import loom.template.DynamicSubClassTest;
	import loom.util.AbcDeserializerTest;
	import loom.util.AbcSerializerTest;
	import loom.util.ClassGeneratorTest;
	import loom.util.DynamicProxyFactoryTest;
	
	import net.digitalprimates.fluint.tests.TestSuite;

	public class LoomSuite extends TestSuite
	{
		public function LoomSuite()
		{
			loom_abc();
			loom_assets_abc();
			loom_swf();
			loom_util();
			
			work_in_progress();
		}
		
		public function work_in_progress() : void
		{
            addTestCase(new SwfTest());
//            addTestCase(new ClassGeneratorTest());
		}
		
		public function loom_swf() : void
		{
            addTestCase(new AbcClassLoaderTest());
		}
		
		public function loom_assets_abc() : void
		{
			addTestCase(new FCDSubClassTest());
		}
		
		public function loom_abc() : void
		{
			addTestCase(new LNamespaceTest());
			addTestCase(new NamespaceSetTest());
			addTestCase(new OpcodeTest());
		}
		
		public function loom_util() : void
		{
            addTestCase(new DynamicProxyFactoryTest());
            addTestCase(new DynamicSubClassTest());
            addTestCase(new AbcDeserializerTest());
            addTestCase(new AbcSerializerTest());
			addTestCase(new ConstantPoolTest());

//			addTestCase(new ClassConverterTest());
//			addTestCase(new AbcToClassDefinitionTest());
		}		
	}
}