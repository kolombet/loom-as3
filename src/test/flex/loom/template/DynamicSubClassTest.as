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
package loom.template
{
	import flash.utils.ByteArray;
	
	import loom.TestConstants;
	import loom.util.AbcDeserializer;
	import loom.loom_namespace;

	import net.digitalprimates.fluint.tests.TestCase;

	public class DynamicSubClassTest extends TestCase
	{
		/**
		 * Test to make sure that the call to the original superclass method works as expected.
		 */
        public function testOriginalMethodInvocation() : void
        {
        	var fixture : DynamicSubClass = new DynamicSubClass("constructorArg1", "constructorArg2");
        	fixture.methodCallOne("arg1", 100);
        }
        
        /**
        * 
        */
        public function testHandlerInvocation() : void
        {
        	var fixture : DynamicSubClass = new DynamicSubClass("constructorArg1", "constructorArg2");
        	fixture.loom_namespace::setHandler(
        	   "methodCallOne",
        	   function(invocation : MethodInvocation) : *
        	   {
                   trace("Before method: " + invocation.methodName);
                   assertEquals(100, invocation.proceed());
                   trace("After method: " + invocation.methodName);
 
                   return 50;
        	   }
        	);
        	
        	assertEquals(50, fixture.methodCallOne("arg1", 100));
        }
	}
}