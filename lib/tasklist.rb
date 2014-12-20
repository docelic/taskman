module TASKMAN

	class Tasklist

		attr_accessor :tasks

		def save
			self.save_to_yaml
		end
		def load
			self.load_from_yaml
		end

		def save_to_yaml
			@data[:VERSION]= $opts['version']
			tf= File.join $opts['data-dir'], $opts['data-file']
			content= @data.to_yaml
			File.write tf, content
		end
		def load_from_yaml
			tf= File.join $opts['data-dir'], $opts['data-file']
			@data= if File.exists? tf
				YAML.load_file tf
			else
				{ :tasks => { }}
			end
		end

		def tasks
			@data[:tasks]
		end

		def version
			@data[:VERSION]
		end
	end
end
