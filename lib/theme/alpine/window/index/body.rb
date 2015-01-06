module TASKMAN

	class Theme::Window::Index::Body < Window

		attr_reader :l

		def initialize arg= {}
			super

			f= $session.format
			h= f% [ ' ', 'ID', ' DB ', 'SUBJECT']
			self<< Label.new( name: 'TH', text: h, :'.expand'=> 'h')

			@l= MVCList.new( name: 'list', autobind: 0, focus: 1)
			l<< MenuAction.new( name: 'pos_up')
			l<< MenuAction.new( name: 'pos_down')
			l<< MenuAction.new( name: 'pos_pgup')
			l<< MenuAction.new( name: 'pos_pgdown')
			l<< MenuAction.new( name: 'pos_home')
			l<< MenuAction.new( name: 'pos_end')

			$session.sth.each do |t|
				s= $session.format% [ t.flag, t.id, s, t.subject]
				@l<< ListItem.new( name: t.id.to_s, text: s, can_focus: 1)
			end
			if $session.sth.size== 0
				@l<< ListItem.new
			end

			self<< @l

			# If focusing list to specific position was requested,
			# save that so we can set this position during init()
			# later.
			if arg[:pos] then @pos= arg[:pos] end
			if arg[:id] then @id= arg[:id] end

			# XXX Is it alright that we do this manually variable by
			# variable like above? Doesn't seem really good.
		end

		def init arg= {}
			@l.init arg.merge( pos: @pos, id: @id)
		end
	end
end
