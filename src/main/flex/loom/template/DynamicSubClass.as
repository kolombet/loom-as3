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
// Compile with: asc -import BaseClass.abc -import MethodInvocation.abc -import loom_namespace.abc DynamicSubClass.as 
package loom.template
{
	import flash.utils.Dictionary;
	
	import loom.loom_namespace;

	public class DynamicSubClass extends BaseClass
	{
        loom_namespace var handlerMappings : Dictionary;
		
		public function DynamicSubClass(constructorArg1 : String, constructorArg2 : String)
		{
			super(constructorArg1, constructorArg2);
			
			loom_namespace::handlerMappings = new Dictionary();
		}
		
		loom_namespace function setHandler(methodName : String, closure : Function) : void
		{
			loom_namespace::handlerMappings[methodName] = closure;
		}
		
		loom_namespace function proxyInvocation(invocation : MethodInvocation) : *
		{
			var closure : Function = loom_namespace::handlerMappings[invocation.methodName];
			if (Boolean(closure))
			{
				return closure.apply(this, [invocation]);
			}
			else
			{
				return invocation.proceed();
			}
		}
		
		override public function methodCallOne(arg1 : String, arg2 : Number) : int
		{
			return loom_namespace::proxyInvocation(new MethodInvocation(this, "methodCallOne", arguments, super.methodCallOne));
		} 

		override public function methodCallTwo(arg1 : String, arg2 : Number, arg3 : Object) : void
		{
			loom_namespace::proxyInvocation(new MethodInvocation(this, "methodCallTwo", arguments, super.methodCallTwo));
		} 

		override public function methodCallThree(arg1 : String, arg2 : Number) : String
		{
			return loom_namespace::proxyInvocation(new MethodInvocation(this, "methodCallThree", arguments, super.methodCallThree));
		} 
	}
}