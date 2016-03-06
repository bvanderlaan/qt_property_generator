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