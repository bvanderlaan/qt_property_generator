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

if (ARGV.include?("--help"))
	puts "HELP!"
	exit 0
end

if (ARGV.count < 2)
	puts "ERROR: You did not provide enough parameters."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -1
end

new_property = NewProperty.new(ARGV)

unless ( new_property.valid? )
	puts "ERROR: You provided invalid parameters."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -2
end

unless ( File.file?("#{new_property.class_name}.hpp") && File.file?("#{new_property.class_name}.cpp") )
	puts "ERROR: One or both of the given files don't exist:"
	puts "\t* #{new_property.class_name}.hpp"
	puts "\t* #{new_property.class_name}.cpp"
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -3
end

property_object = new_property.property

definition_file_content = File.read("#{new_property.class_name}.hpp")
definition_file_content = definition_file_content.insert( ( definition_file_content.rindex(/Q_OBJECT/) + "Q_OBJECT".length), "\n#{property_object.property_macro}" )
definition_file_content = definition_file_content.insert( ( definition_file_content.rindex(/};/) - 1), "\n#{property_object.definitions}" )

File.open("#{new_property.class_name}.hpp", 'w') do |file|
	file.write( definition_file_content ) 
end

File.open( "#{new_property.class_name}.cpp", 'a' ) do |f|
	f.puts "\n\n"
	f.puts property_object.source
end


