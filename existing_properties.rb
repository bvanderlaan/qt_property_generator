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
class ExistingProperties
	attr_reader :class_name, :header_ext, :source_ext

	def initialize( args )
		@source_header_file = args.header_file_name
		@class_name = File.basename(@source_header_file,File.extname(@source_header_file))
		@header_ext = File.extname(@source_header_file)
		@source_ext = args.source_extension
		@all_properties = Array.new

		raise FileNotFoundError, "#{@source_header_file}"  unless File.file?(@source_header_file)

		read_all_existing_properties
	end

	def definitions
		properties_definition = "\n"
		@all_properties.each do |property|
			properties_definition += property.definitions
		end
		return properties_definition
	end

	def source
		properties_source = ""
		@all_properties.each do |property|
			properties_source += property.source
		end
		return properties_source
	end

private
	def read_all_existing_properties
		File.open( @source_header_file ).each do |line|
			if line.include? "Q_PROPERTY"
				property_object = property_parser( line )
				if property_object
					@all_properties.push( property_object )
				end
			end
		end
	end

	def property_parser( q_property_string )
		property_object = nil
		property_details = q_property_string.lstrip.split(" ")
		property_details.delete_at(0)
		property_details.pop

		if (property_details.count >= 6)
			type = property_details[0]
			name = property_details[1]
			getter = property_details[3]
			if property_details[4] == "WRITE"
				setter = property_details[5]
			else
				notifier = property_details[5]
			end
			if (property_details.count >= 8)
				notifier = property_details[7]
			end

			if q_property_string.include? "WRITE"
				property_object = ReadWriteProperty.new( @class_name, type, name, getter, setter, notifier )
			else
				property_object = ReadOnlyProperty.new( @class_name, type, name, getter, notifier )
			end
		end
		return property_object
	end
end