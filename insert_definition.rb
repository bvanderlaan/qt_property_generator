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
		@tab = "\t" * property.number_of_tabs
		@tab_less_one = "\t" * (property.number_of_tabs - 1)
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
		definition_file_content = insert_methods( definition_file_content )
		definition_file_content = insert_signals( definition_file_content )
		definition_file_content = insert_variables( definition_file_content )
		definition_file_content = insert_fix_for_class_ending( definition_file_content )
		return definition_file_content
	end

	def insert_methods( definition_file_content )
		insertion_point = definition_file_content.rindex(/};/) - 1
		content_to_insert = "\n#{@tab_less_one}public:\n#{@tab}#{@property.method_definition}".gsub!( ";", ";\n#{@tab}").rstrip()

		return definition_file_content.insert( insertion_point, content_to_insert )
	end

	def insert_signals( definition_file_content )
		content_to_insert = "\n#{@tab}#{@property.signal_definition}".gsub!( ";", ";\n#{@tab}").rstrip()
		insertion_point = definition_file_content.rindex(/};/) - 1

		if ( definition_file_content.include?("protected:") ) 
			insertion_point = definition_file_content.rindex(/protected:/)
		elsif ( definition_file_content.include?("private:") )
			insertion_point = definition_file_content.rindex(/private:/)
		end

		if ( definition_file_content.include?("signals:") )
			insertion_point = definition_file_content.rindex(/signals:/) + "signals:".length
		else
			content_to_insert = "\n\n#{@tab_less_one}signals:#{content_to_insert}"
		end

		return definition_file_content.insert( insertion_point, content_to_insert )
	end

	def insert_variables( definition_file_content )
		insertion_point = definition_file_content.rindex(/};/) - 1
		content_to_insert = "\n#{@tab}#{@property.variable_definition}".gsub!( ";", ";\n#{@tab}").rstrip()

		if ( definition_file_content.include?("private:") )
			insertion_point = definition_file_content.rindex(/private:/) + "private:".length
		else
			content_to_insert = "\n\n#{@tab_less_one}private:#{content_to_insert}"
		end

		return definition_file_content.insert( insertion_point, content_to_insert )
	end

	def insert_fix_for_class_ending( definition_file_content )
		if ( @property.number_of_tabs > 1 )
			insertion_point = definition_file_content.rindex(/};/) - 1
			return definition_file_content.insert( insertion_point, "\n" )
		end
		return definition_file_content
	end
end


class InsertFullDefinition < InsertDefinition
private
	def generate_definition
		definition_file_content = super
		return definition_file_content.insert( ( definition_file_content.rindex(/Q_OBJECT/) + "Q_OBJECT".length), "\n#{@tab}#{@property.property_macro}" )
	end
end

class InsertTestDefinition < InsertDefinition
private
	def generate_definition
		definition_file_content = File.read("#{@definition_file}")
		definition_file_content = insert_methods( definition_file_content )
		definition_file_content = insert_fix_for_class_ending( definition_file_content )
		return definition_file_content
	end

	def insert_methods( definition_file_content )
		content_to_insert = "\n#{@tab}#{@property.method_definition}".gsub!( ";", ";\n#{@tab}").rstrip()
		insertion_point = definition_file_content.rindex(/};/) - 1

		if ( definition_file_content.include?("private slots:") )
			insertion_point = definition_file_content.rindex(/private slots:/)
		else
			content_to_insert = "\n#{@tab_less_one}private slots:#{content_to_insert}"	
		end
		
		return definition_file_content.insert( insertion_point, content_to_insert )
	end
end