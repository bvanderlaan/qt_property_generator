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

require_relative 'user_options'

class NewPropertyUserOptions < UserOptions
	attr_reader :class_name, :name, :type

	def header_file_name
		"#{@class_name}#{@header_extension}"
	end

	def read_only?
		@read_only
	end

protected
	def handle_first_flag(flag)
		@class_name = File.basename(flag,File.extname(flag))
	end

	def rout_flag_handleing(flag)
		if (flag == "--readonly")
			@read_only = true
		elsif (flag.include?(":"))
			parts = split_flag(flag, ":", 2)
			@name = parts[0]
			@type = parts[1]
		else
			super(flag)
		end
	end
end