module TASKMAN

	class Label < Widget

		def initialize *arg
			super
			@widget= 'label'
		end

	end

	class Label_hotkey < Label
	end

	class Label_spacer < Label
	end

	class Label_shortname < Label
	end

end
