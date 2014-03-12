module TASKMAN

	class Theme::Window::Main::Body < Window

		def initialize *arg
			super()

			@widget= :vbox

			l1= Label.new( '.expand' => 'vh')
			list= List.new( '.tie' => 'c')
			list<< ListItem.new( :text => 'One')
			list<< ListItem.new( :text => 'Two')
			list<< ListItem.new( :text => 'Three')
			list<< ListItem.new( :text => 'Four')
			list<< ListItem.new( :text => 'Five')
			l2= Label.new( '.expand' => 'vh')

			self<< l1
			self<< list
			self<< l2
		end

	end

end
