module TASKMAN
  class Theme::Window::Hello2 < Theme::Window
		require 'theme/alpine/window/main/header'
		#require 'theme/alpine/window/main/status'
		#require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new(   arg.merge( :name=> :header, :title=> ( arg[:title]|| _('HELLO, WORLD!'))))

			i= Textedit.new(  :name=> 'input',  '.expand'=> 'h')
			i<< ListItem.new(                                    :text=> _('Input: (Type text and press Ctrl+P)'))
			o= Label.new(     :name=> 'output', '.expand'=> 'h', :text=> _('Value of input: '))

			i.add_action( :read_self_text)

			self<< i
			self<< o
		end
	end
end
