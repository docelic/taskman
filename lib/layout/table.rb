module TASKMAN

	class Table < Layout

		def initialize *arg
			super

			@widget= 'table'
		end

	end

	class Tablebr < Layout

		def initialize *arg
			super

			@widget= 'tablebr'
		end

	end

	# This is our implementation of basically a List widget, but powered by
	# a table. It allows us to insert different widgets into a row, which
	# is not possible with List's fixed ListItems.
	class TableList < Table
		attr_accessor :prev_row

		def initialize arg= {}
			super
			@prev_row= nil
		end
	end

	class RowSelect < Input
		def initialize arg= {}
			super( { text: '', :'.expand'=> '0', size: 1, process: 0}.merge arg)
			@instant= true
		end
	end

	class Row < Widget
		@widget= nil

		# To rows, we add a focusable but non-modifiable input box in
		# first column. This will allow table rows to change focus
		# without any particular action on our side, and then we'll
		# just color all the columns in the same row appropriately.
		def initialize arg= {}
			super

			i= RowSelect.new
			i.add_action( :select_row)

			self<< i
		end
	end

end
