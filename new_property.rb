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

class NewProperty
	attr_reader :class_name, :header_ext, :source_ext, :number_of_tabs, :property_name

	def initialize(args)
		@class_name = args.class_name
		@property = nil
		@read_only = args.read_only?
		@property_name = args.name
		@type = args.type
		@header_ext = args.header_extension
		@source_ext = args.source_extension
		@number_of_tabs = args.number_of_tabs

		raise ArgumentError, "Expected arguments missing."  unless( valid? )
		create_property
	end

	def valid?
		return ( not @property_name.nil? and not @type.nil? )
	end

	def read_only?
		@read_only
	end

	def source
		@property ? @property.source : ""
	end

	def method_definition
		@property ? @property.method_definition : ""
	end

	def signal_definition
		@property ? @property.notifier_definition : ""
	end

	def variable_definition
		@property ? @property.member_variable_definition : ""
	end

	def property_macro
		@property ? @property.property_macro : ""
	end

private
	def create_property
		if ( valid? )
			getter_prefix = @type == "bool" ? "" : "get"
			if ( @read_only )
				@property = ReadOnlyProperty.new( @class_name, @type, @property_name, "#{getter_prefix}#{@property_name.capitalize_first}", "#{@property_name.uncapitalize}Changed" )
			else
				@property = ReadWriteProperty.new( @class_name, @type, @property_name, "#{getter_prefix}#{@property_name.capitalize_first}", "set#{@property_name.capitalize_first}", "#{@property_name.uncapitalize}Changed" )
			end
		end
	end
end

class TestableNewProperty < NewProperty
	attr_reader :test_path

	def initialize(args)
		super(args)
		@make_unit_tests = args.make_unit_tests?
		@test_path = args.test_path
	end
	def make_unit_tests?
		@make_unit_tests
	end

	def type
		@property ? @property.type : ""
	end

	def getter_name
		@property ? @property.getter : ""
	end

	def signal_name
		@property ? @property.notifier : ""
	end

	def setter_name
		( @read_only && @property ) ? @property.setter : ""
	end
end