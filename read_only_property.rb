=begin

 Copyright 2016 ImaginativeThinking

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
=end

class String
  def capitalize_first
  	self[0, 1].upcase + self[1..-1]
  end
end

class ReadOnlyProperty
	def initialize(class_name,type, name, getter, notifier)
		@class_name = class_name
		@type = type
		@name = name
		@getter = getter
		@notifier = notifier
	end

	def definitions
		code = "\t/// The #{@name.capitalize_first} Property\n"
		code += self.getter_definition		
		code += self.notifier_definition
		code += self.member_variable_definition
		code += "\t//////////////////////////////////\n"
		return code
	end

	def source
		code = self.getter_source
		return code
	end

	def property_macro
		return "\tQ_PROPERTY( #{@type} #{@name} READ #{@getter} NOTIFY #{@notifier} )"
	end

protected
	def notifier_definition
		notifier = "\nsignals:\n"
		notifier += "    void #{@notifier}( #{@type} #{@name} );\n\n"
		return notifier
	end 
	def member_variable_definition
		code = "private:\n"
		code += "    #{@type} m_#{@name};\n\n"
	end
	def getter_definition
		getter = "public:\n"
		getter += "    #{@type} #{@getter}() const;\n"
		return getter
	end
	def getter_source
		code = "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
		code += "#{@type} #{@class_name}::#{@getter}() const\n"
		code += "{\n"
		code += "    return m_#{@name};\n"
		code += "}\n\n"
	end
end