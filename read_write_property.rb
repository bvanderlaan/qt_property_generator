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

class ReadWriteProperty < ReadOnlyProperty
	attr_reader :setter
	def initialize(class_name, type, name, getter, setter, notifier)
		@class_name = class_name
		@type = type
		@name = name
		@getter = getter
		@setter = setter
		@notifier = notifier
	end

	def method_definition
		code = super
		code += "void #{@setter}( #{@type} #{@name} );"
	end

	def source
		code = super
		code += self.setter_source
		return code
	end

	def property_macro
		return "Q_PROPERTY( #{@type} #{@name} READ #{@getter} WRITE #{@setter} NOTIFY #{@notifier} )"
	end

protected
	def setter_source
		code = "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
		code += "void #{@class_name}::#{@setter}( #{@type} #{@name} )\n"
		code += "{\n"
		code += "    if ( m_#{@name} != #{@name} )\n"
		code += "    {\n"
		code += "        m_#{@name} = #{@name};\n"
		code += "        emit #{@notifier}( m_#{@name} );\n"
		code += "    }\n"
		code += "}\n\n"
	end
end