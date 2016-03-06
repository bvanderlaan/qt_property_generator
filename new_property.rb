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

class String
  def uncapitalize 
    self[0, 1].downcase + self[1..-1]
  end
  def capitalize_first
  	self[0, 1].upcase + self[1..-1]
  end
end

class NewProperty
	attr_reader :name, :type, :class_name

	def initialize(args)
		if(args.count > 0)
			@read_only = false
			@class_name = File.basename(args[0],File.extname(args[0]))	

			args.delete_at(0)
			args.each do |arg|
				if ( arg == "--readonly" )
					@read_only = true
				elsif ( arg.include?(":") )
					parts = arg.split(":")
					@name = parts[0]
					@type = parts[1]
				end
			end
		end
	end

	def read_only?
		@read_only
	end

	def valid?
		return ( not @name.nil? and not @type.nil? )
	end

	def property
		if ( @read_only )
			return ReadOnlyProperty.new( @class_name, @type, @name, "get#{@name.capitalize_first}", "#{@name.uncapitalize}Changed" )
		else
			return ReadWriteProperty.new( @class_name, @type, @name, "get#{@name.capitalize_first}", "set#{@name.capitalize_first}", "#{@name.uncapitalize}Changed" )
		end
	end
end