# File implementing generic widget functions.
# In STFL, there is no inherent difference between layout
# and widget elements like there is in e.g. Qt, but we
# keep Qt's logic.

module TASKMAN

	class Widget < StflBase

		# If widget is set to instant(), its primary action will be
		# executed as soon as the widget is focused. (Otherwise it would
		# have been executed only after ENTER is pressed.)
		attr_accessor :instant

		def initialize arg= {}
			super
			@instant||= false
		end

	end

end
