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
	import loom.abc.enum.ConstantKind;
	import loom.abc.BaseMultiname;
	
	import loom.util.StringUtil;
	
    /**
     * Loom representation of <code>Trait_Slot</code> or <code>Trait_Const</code> in the ABC file format.
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Slot and const traits" in the AVM Spec (page 30)
     */
	public class SlotOrConstantTrait extends TraitInfo
	{
		public var slotId : int;
		public var typeMultiname : BaseMultiname;
		public var vindex : int;
		public var vkind : ConstantKind;
		
		public function SlotOrConstantTrait()
		{
			super();
		}
		
		public function toString() : String
		{
            return StringUtil.substitute(
                "SlotOrConstantTrait[name={0}, metadata={1}, kind={2}, slot={3}, typeName={4}, vindex={5}, vkind={6}]",
                super.traitMultiname,
                metadata,
                traitKind.description,
                slotId,
                typeMultiname,
                vindex,
                vkind
            );
		}
	}
}