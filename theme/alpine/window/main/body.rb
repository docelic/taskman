module TASKMAN

	class Theme::Window::Main::Body < Vbox

		def initialize *arg
			super()

			@name= 'body'

			# Spacer 1
			l1= Label.new( '.expand' => 'vh')

			# Main list ###########
			list= List.new( :name => :lst, '.tie' => 'tb')
			menu= [
				MenuAction.new( :name => :help),
				MenuAction.new( :name => :create),
				MenuAction.new( :name => :index),
				MenuAction.new( :name => :listfolders),
				MenuAction.new( :name => :quit),
			]
			# Show items in the list
			menu.each do |a|
				li= ListItem.new( :text => a.menu_text, :can_focus => 1)
				li<< a
				list<< li
				list<< ListItem.new( :can_focus => 0) # Spacer
			end

			# Spacer 2
			l2= Label.new( '.expand' => 'vh')

			self<< l1
			self<< list
			self<< l2
		end

	end

end
