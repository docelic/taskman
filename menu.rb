# File implementing generic menu functions.

module TASKMAN

	class Menu < StflBase

		attr_reader :actions

		def initialize *arg
			super

			@actions= []
			@actions_hash= {}

			@hotkeys_hash= {}
		end

	end

end
