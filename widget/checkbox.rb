module TASKMAN

	class Checkbox < Widget

		def initialize *arg
			super
			@widget= 'checkbox'
		end

		def toggle
			if self.var_value== 0
				self.var_value= 1
			else
				self.var_value= 0
			end
		end

	end

	class Checkbox_hotkey < Checkbox
	end

	class Checkbox_spacer < Checkbox
	end

	class Checkbox_shortname < Checkbox
	end

end
