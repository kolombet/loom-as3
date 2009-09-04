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
	import loom.util.StringUtil;

    /**
     * Loom representation of <code>Trait_Function</code> in the ABC file format.
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Function traits" in the AVM Spec (page 31)
     */ 	
	public class FunctionTrait extends TraitInfo
	{
        public var functionSlotId : int;
        public var functionMethod : MethodInfo;

		public function FunctionTrait()
		{
			super();
		}

        public function toString() : String
        {
            return StringUtil.substitute(
	            "FunctionTrait[name={0}, functionSlotId={1}, method={2}]",
	            traitMultiname,
	            functionSlotId,
	            functionMethod
            );
        }		
	}
}