module TASKMAN

	class Theme::Window::Main::Body < Vbox

		def initialize arg= {}
			super

			# Spacer 1
			l1= Label.new(    :name=> "#{@name}_space1", '.expand' => 'vh')

			# Main list ###########
			list= List.new(   :name=> "#{@name}_list", '.tie'=> 'tb', :pos=> 4)
			menu= [
				MenuAction.new( :name=> :help),
				MenuAction.new( :name=> :create),
				MenuAction.new( :name=> :index),
				MenuAction.new( :name=> :listfolders),
				MenuAction.new( :name=> :quit),
			]
			# Show items in the list
			i= 1
			menu.each do |a|
				li= ListItem.new( :name=> "#{@name}_list_#{a.name}", :text => a.menu_text, :can_focus => 1)
				# XXX re-enable
				#li<< a
				list<< li
				list<< ListItem.new( :name=> "#{@name}_listitem#{i}", :can_focus => 0) # Spacer
				i= i+ 1
			end

			# Spacer 2
			l2= Label.new(   :name=> "#{@name}_space2", '.expand' => 'vh')

			self<< l1
			self<< list
			self<< l2
		end
	end
end
