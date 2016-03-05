class ReadWriteProperty < ReadOnlyProperty
	def initialize(class_name, type, name, getter, setter, notifier)
		@class_name = class_name
		@type = type
		@name = name
		@getter = getter
		@setter = setter
		@notifier = notifier
	end

	def definitions
		code = "\t/// The #{@name.capitalize_first} Property\n"
		code += self.getter_definition	
		code += self.setter_definition	
		code += self.notifier_definition
		code += self.member_variable_definition
		code += "\t//////////////////////////////////\n"
		return code
	end

	def source
		code = super
		code += self.setter_source
		return code
	end

	def property_macro
		return "\tQ_PROPERTY( #{@type} #{@name} READ #{@getter} WRITE #{@setter} NOTIFY #{@notifier} )"
	end

	protected
	def setter_definition
		return "    void #{@setter}( #{@type} #{@name} );\n"
	end
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