module TASKMAN
	class Session
		# List of active/existing sessions
		@@sessions= []

		attr_accessor :category, :category_name
		attr_accessor :db

		def initialize arg= {}
			super()
			@name= arg[:name]|| 'default'
			@category= arg[:category]|| nil
			@category_name= if @category then @category.name else '' end

			self.update
			@@sessions<< self
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
			if @category
				@category_name= @category.name
				@db= @category.items
			else
				@category_name= _('ALL')
				@db= Item.all
			end
		end
	end
end
