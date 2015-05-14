module TASKMAN

	class Theme::Window::List::Body < Window

		def initialize arg= {}
			super

			@l= List.new( name: "#{@name}_list", focus: 1)

			li= ListItem.new( name: '', text: '  ALL')
			a= MenuAction.new( name: 'index', hotkey: 'ENTER', shortname: _('View Fldr'))
			a.function= proc{ |arg| $session.folder= nil; a.index }
			li<< a
			@l<< li

			Folder.all.each do |c|
				li= ListItem.new( name: c.id.to_s, text: '  '+ c.name)

				a= MenuAction.new( name: 'index', hotkey: 'ENTER', shortname: _('View Fldr'))
				a.function= proc{ |arg| $session.folder= c; a.index }
				li<< a

				@l<< li
			end

			self<< @l

			if arg[:pos] then @pos= arg[:pos] end
			if arg[:pos_name] then @pos_name= arg[:pos_name] end
		end

		def init arg= {}
			@l.init arg.merge( pos: @pos, pos_name: @pos_name)
		end
	end
end
