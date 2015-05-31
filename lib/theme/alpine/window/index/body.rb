module TASKMAN

	class Theme::Window::Index::Body < Window

		attr_reader :l

		def initialize arg= {}
			super

			f= $session.format
			h= f.superformat $opts['index-titles']
			self<< Label.new( name: 'TH', text: h, :'.expand'=> 'h')

			@l= MVCList.new( name: 'list', autobind: 0, focus: 1)
			l<< MenuAction.new( name: 'pos_up')
			l<< MenuAction.new( name: 'pos_down')
			l<< MenuAction.new( name: 'pos_pgup')
			l<< MenuAction.new( name: 'pos_pgdown')
			l<< MenuAction.new( name: 'pos_home')
			l<< MenuAction.new( name: 'pos_end')


			nitems= 0
			$session.sth.reload.includes( :status).includes( :categorizations).where( $session.where).order( $session.order).each do |t|
				nitems+= 1

				sfid= $session.folder ? $session.folder.id : nil
				cat= t.categorizations( folder_id: sfid).first
				pri= cat ? cat.priority : nil

				s= $session.format.superformat( {
				  :pre => $opts['content-pre'],
					:flags =>  t.flag,
					:id => t.id,
					:status => t.status ? t.status.name : nil,
					:subject => t.subject,
					:priority => pri,
				})

				i= ListItem.new( name: t.id.to_s, text: s, can_focus: 1)
				i<< MenuAction.new( name: 'select_task_e', shortname: 'View')
				@l<< i
			end
			if nitems== 0
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
