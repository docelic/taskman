module TASKMAN

	class Theme::Window::Colortest::Body < Window
		require 'theme/alpine/window/colortest/colors'

		def initialize arg= {}
			super
			@widget= nil

			colors= Theme::Window::Colortest::Colors.new
			self<< colors
		end
	end
end
