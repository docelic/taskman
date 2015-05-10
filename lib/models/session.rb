module TASKMAN
	class Session
		# List of active/existing sessions
		@@sessions= []

		attr_accessor :folder, :folder_name
		attr_accessor :dbh, :dbn, :sth #, :item
		attr_accessor :format
		attr_accessor :flags
		attr_accessor :whereis
		attr_accessor :show_next_key

		def initialize arg= {}
			super()

			@@sessions<< self

			@name= arg[:name]|| 'default'

			@folder= arg[:folder]|| nil
			@folder_name= if @folder then @folder.name else '' end

			# For attaching in-session flags/mark to items
			@flags= {}

			# XXX WIP-- this needs to be per-window, and basically be an array
			# that is joined, so that we know how many args to give in
			#  %..., and it should also be named if possible.
			@format= ' %1s %-4s %-7s %s'

			#@item= nil

			@whereis= []
			def @whereis.<< arg
				super
				# Make sure history length does not exceed config setting
				while self.size> $opts['history-lines']
					self.shift
				end
			end

			self.update
		end

		def self.all
			@@sessions
		end

		def self.find(param)
			all.detect{ |s| s.to_param== param }|| raise( ActiveRecord::RecordNotFound)
		end

		def to_param
			@name
		end

		# Sync different variables within session
		def update
			@dbh= Item::Main
			@dbn= $opts['main-db']
			# Is assignation of @sth here overriding any
			# composed pieces, like .limit(), .where() etc.
			if @folder
				@folder_name= @folder.name
				@sth= @folder.items
			else
				@folder_name= _('ALL')
				@sth= Item.all
			end
		end
	end
end
