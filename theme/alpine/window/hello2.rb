module TASKMAN
  class Theme::Window::Hello2 < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			i= Textedit.new( :name => 'input',  '.expand' => 'h')
			i<< ListItem.new( :text => 'Input: (Type text and press Ctrl+P)')
			o= Label.new( :name => 'output', '.expand' => 'h', :text => 'Value of input: ')

			i.add_action( :read_self_text)

			self<< i
			self<< o
		end

	end
end
