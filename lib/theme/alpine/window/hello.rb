module TASKMAN
  class Theme::Window::Hello < Theme::Window
		require 'theme/alpine/window/main/header'
		#require 'theme/alpine/window/main/status'
		#require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new(   arg.merge( name: :header, title: ( arg[:title]|| _('HELLO, WORLD!'))))

			self<< Label.new( name: 'lbl1', text: 'Hello, World!')

			vbox= Vbox.new( name: 'menu', :'.expand' => 'h')

			self<< vbox
		end
	end
end
