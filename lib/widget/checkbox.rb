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

end
