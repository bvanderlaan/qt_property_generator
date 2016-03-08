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

require_relative 'read_only_property'
require_relative 'read_write_property'
require_relative 'new_property'
require_relative 'append_source'
require_relative 'insert_definition'
require_relative 'new_property_user_options'
require_relative 'property_unit_tests'

if (ARGV.include?("--help"))
	puts "Generate Property (c)2016 ImaginativeThinking"
	puts "==============================================="
	puts "This tool generates the required getters,"
	puts "setters, signals, and member variables to implement"
	puts "the property."
	puts ""
	puts "For more information see:"
	puts "  https://github.com/bvanderlaan/qt_property_generator"
	puts ""
	puts "Usage:"
	puts "  genprop.rb <class name> <property name>:<type> [--header.ext=<extension>]"
	puts "                                                 [--source.ext=<extension>]"
	puts "                                                 [--readonly]"
	puts "                                                 [--test]"
	puts ""
	puts "<class name>               The name of the class this property will be added to"
	puts "--header.ext=<extension>   Optional: override the default header file extension"
	puts "--source.ext=<extension>   Optional: override the default source file extension"
	puts "--readonly                 Optional: Will generate a read-only property"
	puts "--tab=<num>                Optional: override the default number of tabs used"
	puts "--test                     Optional: Adds unit tests to cover the new property"
	puts ""
	puts ""
	puts "Examples:"
	puts "  genprop.rb MyClass name:QString"
	puts "  genprop.rb MyClass model:QObject* --readonly"
	puts "  genprop.rb MyClass name:QString --source.ext=cxx --header.ext=hxx"
	puts "  genprop.rb MyClass name:QString --tab=2"
	puts "  genprop.rb MyClass name:QString --test"
	puts ""
	puts ""
	exit 0
	exit 0
end

if (ARGV.count < 2)
	puts "ERROR: You did not provide enough parameters."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -1
end

begin
	new_property = NewProperty.new( NewPropertyUserOptions.new(ARGV) )
rescue ArgumentError
	puts "ERROR: You provided invalid parameters."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -2
end

begin
	InsertFullDefinition.new( new_property )
rescue FileNotFoundError => file_name
	puts "ERROR: The given file [#{file_name}] does not exist."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -3
end

begin
	AppendSource.new( new_property )
rescue FileNotFoundError => file_name
	puts "ERROR: The given file [#{file_name}] does not exist."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -3
end	

if ( new_property.make_unit_tests? )

	property_unit_tests = PropertyUnitTests.new( new_property )
	begin
		InsertTestDefinition.new( property_unit_tests )
	rescue FileNotFoundError => file_name
		puts "ERROR: The given file [#{file_name}] does not exist."
		puts "Try the following for more help:"
		puts "$ ruby #{$0} --help"
		exit -3
	end

	begin
		AppendSource.new( property_unit_tests )
	rescue FileNotFoundError => file_name
		puts "ERROR: The given file [#{file_name}] does not exist."
		puts "Try the following for more help:"
		puts "$ ruby #{$0} --help"
		exit -3
	end	
end