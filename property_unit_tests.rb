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
  def uncapitalize 
    self[0, 1].downcase + self[1..-1]
  end
  def capitalize_first
  	self[0, 1].upcase + self[1..-1]
  end
end

class PropertyUnitTests
	
	def initialize(property)
		@property = property
		raise ArgumentError, "Expected arguments missing."  unless( @property.valid? )
	end

	def class_name
		"#{@property.class_name}TestSuite"
	end

	def header_ext
		@property.header_ext
	end

	def source_ext
		@property.source_ext
	end

	def number_of_tabs
		@property.number_of_tabs
	end

	def test_path
		@property.test_path
	end

	def method_definition
		code = "void testGetting#{@property.property_name.capitalize_first}();"
		unless @property.read_only?
			code += "void testSetting#{@property.property_name.capitalize_first}();"
			code += "void testSetting#{@property.property_name.capitalize_first}ToSameValue();"
		end
		code += "void testToEnsureThatThe#{@property.property_name.capitalize_first}PropertyExsits();"
	end

	def source
		code = "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
		code += "void #{self.class_name}::testGetting#{@property.property_name.capitalize_first}()\n"
		code += "{\n"
		if ( is_pointer_type? )
			code += "    #{@property.type.chomp("*")} data;\n\n"	
		end
		code += "    #{@property.class_name} cut( #{value}, this );\n"
		if ( is_pointer_type? )
		    code += "    QVERIFY( cut.#{@property.getter_name}() == #{value}  );\n"
		else
		    code += "    QCOMPARE( cut.#{@property.getter_name}(), #{value}  );\n"
		end
		code += "}\n\n"

		unless @property.read_only?
			code += "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
			code += "void #{self.class_name}::testSetting#{@property.property_name.capitalize_first}()\n"
			code += "{\n"
			if ( is_pointer_type? )
				code += "    #{@property.type.chomp("*")} data;\n\n"	
			end
			code += "    #{@property.class_name} cut;\n"
			if ( is_pointer_type? )
		    	code += "    QSignalSpy spy( &cut, SIGNAL( #{@property.signal_name}() ) );\n"
		    	code += "    QVERIFY( cut.#{@property.getter_name}() == #{default}  );\n\n"
			else
		    	code += "    QSignalSpy spy( &cut, SIGNAL( #{@property.signal_name}(#{@property.type}) ) );\n"
		    	code += "    QCOMPARE( cut.#{@property.getter_name}(), #{default}  );\n\n"
			end
		    code += "    cut.#{@property.setter_name}( #{value} );\n\n"
		    if ( is_pointer_type? )
			    code += "    QVERIFY( cut.#{@property.getter_name}() == #{value}  );\n"
			else
			    code += "    QCOMPARE( cut.#{@property.getter_name}(), #{value}  );\n"
			end
		    code += "    QCOMPARE( spy.count(), 1 );\n"
		    unless( is_pointer_type? )
		    	code += "    QCOMPARE( spy.takeFirst().at(0).#{variant_convertion}(), #{value}  );\n"
		    end

			code += "}\n\n"
			code += "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
			code += "void #{self.class_name}::testSetting#{@property.property_name.capitalize_first}ToSameValue()\n"
			code += "{\n"
			if ( is_pointer_type? )
				code += "    #{@property.type.chomp("*")} data;\n\n"	
			end
			code += "    #{@property.class_name} cut( #{value}, this );\n"
			if ( is_pointer_type? )
		    	code += "    QSignalSpy spy( &cut, SIGNAL( #{@property.signal_name}() ) );\n"
		    	code += "    QVERIFY( cut.#{@property.getter_name}() == #{value} );\n\n"
			else
		    	code += "    QSignalSpy spy( &cut, SIGNAL( #{@property.signal_name}(#{@property.type}) ) );\n"
		    	code += "    QCOMPARE( cut.#{@property.getter_name}(), #{value} );\n\n"
		    end
		    
		    code += "    cut.#{@property.setter_name}( #{value} );\n"
		    if ( is_pointer_type? )
		    	code += "    QVERIFY( cut.#{@property.getter_name}() == #{value} );\n"
			else
		    	code += "    QCOMPARE( cut.#{@property.getter_name}(), #{value} );\n"
		    end
		    code += "    QCOMPARE( spy.count(), 0 );\n"
			code += "}\n\n"
		end

		code += "///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\n"
		code += "void #{self.class_name}::testToEnsureThatThe#{@property.property_name.capitalize_first}PropertyExsits()\n"
		code += "{\n"
		code += "    #{@property.class_name} cut;\n\n"
		code += "    const QMetaObject *metaobject = cut.metaObject();\n"
     	code += "    int index = metaobject->indexOfProperty( \"#{@property.property_name}\" );\n"
     	code += "    QVERIFY( index != -1 );\n"
		code += "}\n\n"
	end

private
	def value
		case @property.type
		when "QString", "string", "std:string", "wstring", "std:wstring"
			return "QStringLiteral(\"#{@property.property_name.downcase}\")"
		when "int", "uint", "long"
			return "55"
		when "bool"
			return "true"
		else
			if ( @property.type.end_with?("*") )
				return "&data"
			end
		end
	end

	def default
		case @property.type
		when "QString", "string", "std:string", "wstring", "std:wstring"
			return "QStringLiteral(\"\")"
		when "int", "uint", "long"
			return "0"
		when "bool"
			return "false"
		else
			if ( @property.type.end_with?("*") )
				return "nullptr"
			end
		end
	end

	def variant_convertion
		case @property.type
		when "QString", "string", "std:string", "wstring", "std:wstring"
			return "toString"
		when "int", "uint", "long"
			return "toInt"
		when "bool"
			return "toBool"
		end
	end

	def is_pointer_type?
		@property.type.end_with?("*")
	end

end