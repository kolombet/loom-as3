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
	import loom.abc.enum.MultinameKind;
	import loom.util.StringUtil;
	
    /**
     * Loom representation of <code>multiname_info</code> in the ABC file format.
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Multiname" in the AVM Spec (page 23)
     */
	public class Multiname extends NamedMultiname
	{
		private var _namespaceSet : NamespaceSet;
		
		public function Multiname(multiname : String, namespaceSet : NamespaceSet, kind : MultinameKind = null)
		{
			kind = (kind) ? kind : MultinameKind.MULTINAME;
			super(kind, multiname);
			
			assertAppropriateMultinameKind([MultinameKind.MULTINAME, MultinameKind.MULTINAME_A], kind);
			_namespaceSet = namespaceSet;
		}
		
		public function get namespaceSet() : NamespaceSet
		{
			return _namespaceSet;
		}
		
		override public function equals(multiname : BaseMultiname) : Boolean
		{
			var matches : Boolean = false;
			if (multiname is Multiname)
			{
				var cMultiname : Multiname = Multiname(multiname);
				if (cMultiname.namespaceSet)
				{
					if (cMultiname.namespaceSet.equals(this.namespaceSet))
					{
		                if (super.equals(multiname))
		                {
		                    matches = true;
		                }					
					}
				}
			}
			
			return matches;
		}
		
        public function toString() : String
		{
			return StringUtil.substitute(
                "{0}[name={1}, nsset={2}]",
                kind.description,
                name,
                namespaceSet
            );
		}
	}
}