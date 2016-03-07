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
	attr_reader :class_name, :header_ext, :source_ext

	def initialize(args)
		@read_only = false
		@class_name = args.class_name
		@property = nil
		@read_only = args.read_only?
		@name = args.name
		@type = args.type
		@header_ext = args.header_extension
		@source_ext = args.source_extension

		raise ArgumentError, "Expected arguments missing."  unless( valid? )
		create_property
	end

	def valid?
		return ( not @name.nil? and not @type.nil? )
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
			if ( @read_only )
				@property = ReadOnlyProperty.new( @class_name, @type, @name, "get#{@name.capitalize_first}", "#{@name.uncapitalize}Changed" )
			else
				@property = ReadWriteProperty.new( @class_name, @type, @name, "get#{@name.capitalize_first}", "set#{@name.capitalize_first}", "#{@name.uncapitalize}Changed" )
			end
		end
	end
end