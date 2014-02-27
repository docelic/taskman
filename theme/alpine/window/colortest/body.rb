module TASKMAN

	class Theme::Window::Colortest::Body < Window

		def initialize arg= {}
			super

			@widget= nil

			require 'colors'
			colors= Colors.new
			self<< colors
		end

	end

end
