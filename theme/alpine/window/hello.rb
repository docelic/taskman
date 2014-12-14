module TASKMAN
  class Theme::Window::Hello < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Label.new( :name => 'lbl1', :text => 'Hello, World!')

		end

	end
end
