module TASKMAN

	class Theme::Window::Main::Body < Vbox

		def initialize *arg
			super()

			@name= 'body'

			l1= Label.new( '.expand' => 'vh')

			list= List.new( '.tie' => 'c')
			list<< ListItem.new( :text => 'One', :can_focus => 1)
			list<< ListItem.new( :text => '', :can_focus => 0)
			list<< ListItem.new( :text => 'Two', :can_focus => 1)
			list<< ListItem.new( :text => '', :can_focus => 0)
			list<< ListItem.new( :text => 'Three', :can_focus => 1)
			list<< ListItem.new( :text => '', :can_focus => 0)
			list<< ListItem.new( :text => 'Four', :can_focus => 1)
			list<< ListItem.new( :text => '', :can_focus => 0)
			list<< ListItem.new( :text => 'Five', :can_focus => 1)

			l2= Label.new( '.expand' => 'vh')

			self<< l1
			self<< list
			self<< l2
		end

	end

end
