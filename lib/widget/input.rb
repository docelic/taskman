module TASKMAN

	class Input < Widget

		def initialize *arg
			super
			@widget= 'input'
			self<< MenuAction.new( name: 'insert_datetime', default: false)
		end
	end
end
