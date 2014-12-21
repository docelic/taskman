module TASKMAN

	class List < Widget

		def initialize *arg
			super
			@widget= 'list'

			self<< MenuAction.new( :name=> :top_list)
			self<< MenuAction.new( :name=> :bottom_list)
		end

	end

	class ListItem < Widget

		def initialize *arg
			super
			@widget= 'listitem'
		end
	end
end
