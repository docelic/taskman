module TASKMAN
	class Session
		# List of active/existing sessions
		@@sessions= []

		attr_accessor :category

		def initialize arg= {}
			super()
			@name= arg[:name]|| 'default'
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
	end
end
