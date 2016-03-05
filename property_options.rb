class PropertyOptions
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
end