require_relative 'read_only_property'
require_relative 'read_write_property'
require_relative 'property_options'

class String
  def uncapitalize 
    self[0, 1].downcase + self[1..-1]
  end
  def capitalize_first
  	self[0, 1].upcase + self[1..-1]
  end
end

if (ARGV.count == 0)
	puts "You did not provide enough parameters."
	puts "Try the following for more help:"
	puts "$ ruby #{$0} --help"
	exit -1
end

if (ARGV.include?("--help"))
	puts "HELP!"
	exit 0
end

options = PropertyOptions.new(ARGV)

if ( options.read_only? )
	property_object = ReadOnlyProperty.new( options.class_name, options.type, options.name, "get#{options.name.capitalize_first}", "#{options.name.uncapitalize}Changed" )
else
	property_object = ReadWriteProperty.new( options.class_name, options.type, options.name, "get#{options.name.capitalize_first}", "set#{options.name.capitalize_first}", "#{options.name.uncapitalize}Changed" )
end


File.open( "#{options.class_name}.cpp", 'a' ) do |f|
	f.puts "\n"
	f.puts property_object.source
end

definition_file_content = File.read("#{options.class_name}.hpp")
definition_file_content = definition_file_content.insert( ( definition_file_content.rindex(/Q_OBJECT/) + "Q_OBJECT".length), "\n#{property_object.property_macro}" )
definition_file_content = definition_file_content.insert( ( definition_file_content.rindex(/};/) - 1), "\n#{property_object.definitions}" )

File.open("#{options.class_name}.hpp", 'w') do |file|
	file.write( definition_file_content ) 
end
