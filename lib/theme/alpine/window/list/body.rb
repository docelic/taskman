module TASKMAN

	class Theme::Window::List::Body < Window

		def initialize arg= {}
			super

			l= List.new( name: "#{@name}_list")
			l<< ListItem.new( name: '', text: '  ALL')

			Folder.all.each do |c|
				li= ListItem.new( name: c.id.to_s, text: '  '+ c.name)

				a= MenuAction.new( name: 'index', hotkey: 'ENTER')
				a.function= proc{ |arg| $session.folder= c; a.index }
				li<< a

				l<< li
			end

			self<< l
		end
	end
end
