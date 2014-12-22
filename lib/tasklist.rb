module TASKMAN

	class Tasklist

		@@sources= {
			:main=> [ adapter:'mysql2', host:'localhost', username:'taskman', password:'taskman', database:'taskman'],
			:main2=> [ adapter:'mysql2', host:'localhost', username:'taskman2', password:'taskman2', database:'taskman2'],
		}
		@@classes= {
		}

		@@sources.each do |k, v|
			n= k.to_s.ucfirst
			c= Item.const_set n, Class.new( Item)
			#c.table_name= 'items'
			c.establish_connection( *v)
			# Trigger it right now, to notice any errors
			c.connection
			@@classes[k]= c
		end

		def count
			@@classes.values.inject( 0){ |c, s| c+= s.count}
		end

		# This function exists for compatibility with old task access
		# model, but is not intended to be called in real, production
		# setups (i.e. retrieving all tasks at once may not be ideal)
		def tasks
			r= {}
			@@classes.each{ |k, c|
				tasks= c.all # find :all ??
				tasks.each.map{ |t|
					r[ [ k, t.id]]= t
				}
			}
			r
		end

		#def save
		#	self.save_to_yaml
		#end
		#def load
		#	self.load_from_yaml
		#end

		#def save_to_yaml
		#	@data[:VERSION]= $opts['version']
		#	tf= File.join $opts['data-dir'], $opts['data-file']
		#	content= @data.to_yaml
		#	File.write tf, content
		#end
		#def load_from_yaml
		#	tf= File.join $opts['data-dir'], $opts['data-file']
		#	@data= if File.exists? tf
		#		YAML.load_file tf
		#	else
		#		{ :tasks => { }}
		#	end
		#end

		#def tasks
		#	@data[:tasks]
		#end

		#def version
		#	@data[:VERSION]
		#end
	end
end
