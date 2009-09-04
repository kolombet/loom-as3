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
package loom.abc
{
	import loom.abc.enum.NamespaceKind;
	
	import net.digitalprimates.fluint.tests.TestCase;
	
	public class NamespaceSetTest extends TestCase
	{
        private var _fixture : NamespaceSet;
        
        protected override function setUp() : void
        {
        	_fixture = new NamespaceSet();
        }
        
        public function testEquals() : void
        {
        	var namespaceArray : Array = [
        	   new LNamespace(NamespaceKind.NAMESPACE, "namespaceOne"),
        	   new LNamespace(NamespaceKind.NAMESPACE, "namespaceTwo")
        	];  
        	_fixture = new NamespaceSet(namespaceArray);
        	var matchingSet : NamespaceSet = new NamespaceSet(namespaceArray);
        	assertTrue(_fixture.equals(matchingSet));
        	
        	var notMatchingSet : NamespaceSet = new NamespaceSet([new LNamespace(NamespaceKind.EXPLICIT_NAMESPACE, "namespaceThree")]);
        	assertFalse(_fixture.equals(notMatchingSet));
        }
	}
}