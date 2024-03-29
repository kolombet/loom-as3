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
package loom.reflection
{
	import flash.utils.Dictionary;
	
	import loom.util.StringUtil;
	
	/**
	 * Represents metadata annotated on an <code>Annotatable</code> element.
	 * 
	 * <p>
	 * Given the metadata string <code>[TagName(property1="value1", property2="value2")]</code>, the name
	 * attribute of a Metadata object would represent <code>TagName</code> while <code>property1</code> and
	 * <code>property2</code> would be keys in the <code>properties</code> Dictionary, with <code>value1</code>
	 * and <code>value2</code> as their respective values.
	 * </p>
	 * 
	 * @see Annotatable
	 */
	public class Metadata
	{
		public var name : String;
		public var properties : Dictionary;
		
		public function Metadata()
		{
			properties = new Dictionary();
		}
		
		public function toString() : String
		{
			var keyValuePairs : Array = [];
			for (var key : String in properties)
			{
				keyValuePairs.push(key + "=\"" +  properties[key] + "\"");
			}
			
			return StringUtil.substitute(
                "[{0}({1})]",
                name,
                keyValuePairs.join()
			);
		}
	}
}