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

class UserOptions
	attr_reader :header_file_name, :source_extension, :header_extension, :number_of_tabs
	def initialize( args )
		@source_extension = ".cpp"
		@header_extension = ".hpp"
		@number_of_tabs = 1
		@make_unit_tests = false

		handle_first_flag( args[0] )

		args.delete_at(0)
		args.each do |arg|
			rout_flag_handleing(arg)
		end
	end

	def make_unit_tests?
		@make_unit_tests
	end

protected
	def split_flag(flag, delimiter, expected_number)
		parts = flag.split(delimiter)
		raise ArgumentError, "option malformed" unless parts.count == expected_number
		return parts
	end

	def rout_flag_handleing(flag)
		if ( flag.include?("--source.") )
			handle_source_flags( flag["--source.".length..flag.length] )
		elsif ( flag.include?("--header.") )
			handle_header_flags( flag["--header.".length..flag.length] )
		elsif ( flag.include?("--tab=") )
			handle_tab_flags( flag["--tab=".length..flag.length] )
		elsif ( flag.include?("--test") )
			@make_unit_tests = true
		end
	end

	def handle_first_flag(flag)
		@header_file_name = flag
	end

	def handle_source_flags(flag)
		parts = split_flag(flag, "=", 2)
		option = parts[0]
		value = parts[1]

		case option
		when "ext"
			@source_extension = value.start_with?(".") ? value : ".#{value}"
		end
	end

	def handle_header_flags(flag)
		parts = split_flag(flag, "=", 2)
		option = parts[0]
		value = parts[1]

		case option
		when "ext"
			@header_extension = value.start_with?(".") ? value : ".#{value}"
		end
	end

	def handle_tab_flags(num_of_tabs)
		@number_of_tabs = num_of_tabs.to_i > 0 ? num_of_tabs.to_i : 1
	end

end