module TASKMAN

	class Theme::Window::Index::Body < Window

		attr_reader :l

		def initialize arg= {}
			super

			f= $session.format
			h= f% $opts['index-titles']
			self<< Label.new( name: 'TH', text: h, :'.expand'=> 'h')

			@l= MVCList.new( name: 'list', autobind: 0, focus: 1)
			l<< MenuAction.new( name: 'pos_up')
			l<< MenuAction.new( name: 'pos_down')
			l<< MenuAction.new( name: 'pos_pgup')
			l<< MenuAction.new( name: 'pos_pgdown')
			l<< MenuAction.new( name: 'pos_home')
			l<< MenuAction.new( name: 'pos_end')

			$session.sth.reload.order( $session.order).each do |t|

				s= $session.format% {
				  :pre => $opts['content-pre'],
					:flags =>  t.flag,
					:id => t.id,
					:status => t.status,
					:subject => t.subject,
					:priority => t.categorizations( folder_id: $session.folder.id).first.priority,
				}

				i= ListItem.new( name: t.id.to_s, text: s, can_focus: 1)
				i<< MenuAction.new( name: 'select_task_e', shortname: 'View')
				@l<< i
			end
			if $session.sth.size== 0
				@l<< ListItem.new( name: 'empty')
			end

			self<< @l

			# If focusing list to specific position was requested,
			# save that so we can set this position during init()
			# later.
			if arg[:pos] then @pos= arg[:pos] end
			if arg[:pos_name] then @pos_name= arg[:pos_name] end

			# XXX Is it alright that we do this manually variable by
			# variable like above? Doesn't seem really good.
		end

		def init arg= {}
			@l.init arg.merge( pos: @pos, pos_name: @pos_name)
		end
	end
end
