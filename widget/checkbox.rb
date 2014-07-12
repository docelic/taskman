module TASKMAN

	class Checkbox < Widget

		def initialize *arg
			super
			@widget= 'checkbox'
		end

	end

	class Checkbox_hotkey < Checkbox
	end

	class Checkbox_spacer < Checkbox
	end

	class Checkbox_shortname < Checkbox
	end

end
