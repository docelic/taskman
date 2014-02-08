module TASKMAN

	class Theme::Body < Window

		def initialize *arg
			super()

			v= Vbox.new( :@style_normal => 'bg=black,fg=white')
			v<< l= List.new

			l<< ListItem.new( :text => 'BADABADABOY!!!')
			l<< ListItem.new( :text => 'BADABADABOY!!!2')
			l<< ListItem.new( :text => 'BADABADABOY!!!3')
			l<< ListItem.new( :text => 'BADABADABOY!!!4')
			l<< ListItem.new( :text => 'BADABADABOY!!!5')
			l<< ListItem.new( :text => 'BADABADABOY!!!6')


			self<< v
		end

	end

end
