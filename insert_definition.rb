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
class InsertDefinition
	def initialize( property )
		@property = property
		@definition_file = "#{@property.class_name}#{@property.header_ext}"

		raise FileNotFoundError, "#{@definition_file}" unless File.file?("#{@definition_file}")

		write_out_definition( generate_definition )
	end

private
	def write_out_definition( content )
		File.open( "#{@definition_file}", 'w' ) do |f|
			f.write( content )
		end
	end

	def generate_definition
		definition_file_content = File.read("#{@definition_file}")
		return definition_file_content.insert( ( definition_file_content.rindex(/};/) - 1), "\n#{@property.definitions}" )
	end
end
class InsertFullDefinition < InsertDefinition
	def generate_definition
		definition_file_content = super
		return definition_file_content.insert( ( definition_file_content.rindex(/Q_OBJECT/) + "Q_OBJECT".length), "\n#{@property.property_macro}" )
	end
end