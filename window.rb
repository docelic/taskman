# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# Or another way of thinking about it is a portion of the
# screen. (For example, the alpine theme consists of a 'screen'
# with header, body, status and menu windows)

module TASKMAN

	class Window < UiBase

		attr_reader :actions

		def initialize *arg
			@widget= :vbox

			super
		end

	end

end
