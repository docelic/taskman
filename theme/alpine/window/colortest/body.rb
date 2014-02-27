module TASKMAN

	class Theme::Window::Colortest::Body < Window

		def initialize arg= {}
			super

			@widget= nil

			require 'theme/alpine/window/colortest/colors'
			colors= Theme::Window::Colortest::Colors.new
			self<< colors
		end

	end

end
