module TASKMAN

	class Theme::Body < Window

		def initialize *arg
			super()

			#v= Vbox.new( :@style_normal => 'bg=black,fg=white')
			#v<< l= List.new
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!')
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!2')
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!3')
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!4')
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!5')
			#l<< ListItem.new( '.height' => 3, :height => 3, :text => 'BADABADABOY!!!6')
			#self<< v

			@widget= nil

			require 'colors'
			colors= Colors.new
			self<< colors
		end

	end

end
