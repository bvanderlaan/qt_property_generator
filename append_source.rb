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

class FileNotFoundError < IOError
end
class AppendSource
	def initialize( property )
		@property = property
		@source_file = build_source_filename

		raise FileNotFoundError, "#{@source_file}" unless File.file?("#{@source_file}")

		write_out_source
	end
protected
	def build_source_filename
		"#{@property.class_name}#{@property.source_ext}"
	end

private
	def write_out_source
		File.open( "#{@source_file}", 'a' ) do |f|
			f.puts "\n\n"
			f.puts @property.source
		end
	end
end

class AppendTestSource < AppendSource
protected
	def build_source_filename
		"#{@property.test_path}#{@property.class_name}#{@property.source_ext}"
	end
end