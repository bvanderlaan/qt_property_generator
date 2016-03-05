class ReadOnlyProperty
	def initialize(class_name,type, name, getter, notifier)
		@class_name = class_name
		@type = type
		@name = name
		@getter = getter
		@notifier = notifier
	end

	def definitions
		code = "\t/// The #{@name.capitalize} Property\n"
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