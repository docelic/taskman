module TASKMAN

	class Theme::Window::Index::Body < Window

		attr_reader :l, :fmt

		def initialize arg= {}
			super

			@fmt= " %1s %-4s %-6s %s"
			h= @fmt % [ ' ', 'ID', ' DB ', 'SUBJECT']
			self<< Label.new( name: 'TH', text: h, :'.expand'=> 'h')

			@l= MVCList.new( name: 'list', autobind: 0, focus: 1)
			l<< MenuAction.new( name: 'pos_up')
			l<< MenuAction.new( name: 'pos_down')
			l<< MenuAction.new( name: 'pos_pgup')
			l<< MenuAction.new( name: 'pos_pgdown')
			l<< MenuAction.new( name: 'pos_home')
			l<< MenuAction.new( name: 'pos_end')

			@l<< ListItem.new
			self<< @l

			# If focusing list to specific position was requested,
			# save that so we can set this position during init()
			# later.
			if arg[:pos] then @pos= arg[:pos] end
		end

		def init arg= {}
			@l.init arg.merge( pos: @pos)
		end
	end
end