# File implementing generic menu functions.

module TASKMAN

	class Menu < StflBase

		attr_reader :actions, :hotkeys_hash

		def initialize *arg
			super

			@hotkeys_hash= {}
		end

	end

end
