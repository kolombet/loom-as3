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
//compile with: asc -import FullClassDefinition.abc -import custom_namespace.abc -import Interface.abc -import ../../loom/template/MethodInvocation.abc -import ../../loom/template/loom_namespace.abc FCDSubClass.as
package assets.abc
{
	import flash.utils.Dictionary;
	
	import assets.abc.custom_namespace;
	import loom.loom_namespace;
	import loom.template.MethodInvocation;
	
	use namespace custom_namespace;
	use namespace loom_namespace;
	
	public class FCDSubClass extends FullClassDefinition
	{
        loom_namespace var handlerMappings : Dictionary;

		public function FCDSubClass()
		{
			super();
			loom_namespace::handlerMappings = new Dictionary();
		}
		
        override public function methodWithNoArguments() : void
        {
        	loom_namespace::proxyInvocation(new MethodInvocation(this, "methodWithNoArguments", arguments, super.methodWithNoArguments));
        }

        override public function methodWithOptionalArguments(requiredArgument : String, optionalStringArgument : String = null, optionalIntArgument : int = 10) : void
        {
        	loom_namespace::proxyInvocation(new MethodInvocation(this, "methodWithOptionalArguments", [requiredArgument, optionalStringArgument, optionalIntArgument], super.methodWithOptionalArguments));
        }
        
        override public function methodWithRestArguments(requiredArgument : String, ...rest) : void
        {
        	loom_namespace::proxyInvocation(new MethodInvocation(this, "methodWithRestArguments", [requiredArgument, rest], super.methodWithRestArguments));
        }
        
        override public function set setterForInternalValue(value : String) : void
        {
            loom_namespace::proxyInvocation(new MethodInvocation(this, "setterForInternalValue", arguments, null, 2));
        }

        loom_namespace function setProperty(propertyName : String, value : String) : void
        {
            super[propertyName] = value;
        }

        override public function get getterForInternalValue() : String
        {
            return loom_namespace::proxyInvocation(new MethodInvocation(this, "getterForInternalValue", arguments, null, 1));
        }
        
        loom_namespace function getProperty(propertyName : String) : String
        {
        	return super[propertyName];
        }
        
        // The command-line flex-mojos compiler will complain here unless both this class and its superclass import the namespace
        // and use the "use namespace" declaration. The FB compiler is a little more forgiving for some reason.
        override custom_namespace function customNamespaceFunction() : void
        {
        	loom_namespace::proxyInvocation(new MethodInvocation(this, "customNamespaceFunction", arguments, null));
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
	}
}