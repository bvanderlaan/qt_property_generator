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
require_relative 'existing_properties'

if (ARGV.include?("--help"))
	puts "HELP!"
	exit 0
end

if (ARGV.count == 0)
	puts "ERROR: You need to provide a header file to read from."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -1
end

begin
	existing_properties = ExistingProperties.new( ARGV[0] )
rescue ArgumentError => file_name
	puts "Error: The given file [#{file_name}] does not exist."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -2
end

properties_definition = "\n" + existing_properties.all_definitions_s

definition_file_content = File.read("#{existing_properties.class_name}#{existing_properties.header_ext}")
definition_file_content = definition_file_content.insert( ( definition_file_content.rindex(/};/) - 1), "\n#{properties_definition}" )

File.open("#{existing_properties.class_name}#{existing_properties.header_ext}", 'w') do |file|
	file.write( definition_file_content ) 
end

File.open( "#{existing_properties.class_name}.cpp", 'a' ) do |f|
	f.puts "\n\n"
	f.puts existing_properties.all_source_s
end