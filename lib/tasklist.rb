module TASKMAN

	class Tasklist

		attr_accessor :tasks

		def initialize
			super

			@@sources= {
				main: [ adapter:'mysql2', host:'localhost', username:'taskman', password:'taskman', database:'taskman'],
				main2: [ adapter:'mysql2', host:'localhost', username:'taskman2', password:'taskman2', database:'taskman2'],
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

			# Portion of data loaded from DBs and kept in memory
			@tasks= []
		end

		def count
			@@classes.values.inject( 0){ |c, s| c+ s.count}
		end

		# This function exists for compatibility with old task access
		# model, but is not intended to be called in real, production
		# setups (i.e. retrieving all tasks at once may not be ideal)
		def load_all
			ret= []
			@@classes.each{ |k, c|
				tasks= c.all # find :all ??
				ret.push *tasks.map{ |t| [k, t]}
			}
			if debug? :mvc
				pfl _('Loaded total: %d records') % ret.count
			end
			ret
		end

		def by_aid aid
			@tasks.each do |tb|
					if [tb[0], tb[1].id]== aid
						pfl :CK_WINNNNN
						return tb[1]
					end
			end
			nil
		end

		## This is a much better function than the above. The only small
		## drawback of this one is that when a person specifies limit/
		## offset, it invokes each DB with those params instead of
		## decreasing those values as previous databases return records.
		## Would be very easy to fix that though.
		#def get_all arg= {}
		#	ret= {}
		#	found= 0
		#	@@classes.each{ |k, c|
		#		tasks= c.limit( arg[:limit]).offset( arg[:offset])
		#		tasks.each{ |t|
		#			ret[ [ k, t.id]]= t
		#			found+= 1
		#			break if found== arg[:limit]
		#		}
		#	}
		#	ret
		#end

		# The third iteration of the MVC development
		def ensure from= 0, to= -1
			if debug? :mvc
				pfl _('Ensuring tasks are in memory: %d..%d') % [ from, to]
			end
			@tasks= self.load_all
		end
	end
end