require_relative 'read_only_property'
require_relative 'read_write_property'

def property_parser( q_property_string, class_name )
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
			property_object = ReadWriteProperty.new( class_name, type, name, getter, setter, notifier )
		else
			property_object = ReadOnlyProperty.new( class_name, type, name, getter, notifier )
		end
	end
	return property_object
end

if (ARGV.count == 0)
	puts "You need to provide a header file to read from"
	exit -1
end


source_header_file = ARGV[0]

if not File.file?(source_header_file)
	puts "The given file [#{source_header_file}] does not exist"
	exit -2
end

all_properties = Array.new
class_name = File.basename(source_header_file,File.extname(source_header_file))
definition_file_content = ""

File.open( source_header_file ).each do |line|
	definition_file_content << line
	if line.include? "Q_PROPERTY"
		property_object = property_parser( line, class_name )
		if property_object
			all_properties.push( property_object )
		end
	end
end

File.open( "#{class_name}.cpp", 'a' ) do |f|
	f.puts "\n"
	all_properties.each do |property|
		f.puts property.source
	end
end

properties_definition = "\n"
all_properties.each do |property|
	properties_definition += property.definitions
end

File.open("#{class_name}.hpp", 'w') do |file|
	file.write( definition_file_content.insert( ( definition_file_content.rindex(/};/) - 1), "\n#{properties_definition}" ) ) 
end


