module TASKMAN

	class List < Widget

		def initialize *arg
			super
			@widget= 'list'
		end

	end

	class ListItem < Widget

		def initialize *arg
			super
			@widget= 'listitem'
		end

	end

end
