module TASKMAN
  class Theme::Window::Help < Theme::Window

		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new(   arg.merge( name: :header, title: ( arg[:title]|| _('HELP'))))

			#########################################################
			# In-place definition of body
			t= Textview.new( name: 'body', focus: 1, text: Help.text)
			t<< MenuAction.new( name: :top_help)
			t<< MenuAction.new( name: :bottom_help)
			t<< MenuAction.new( name: :whereis, hotkey: '/')
			t<< MenuAction.new( name: :whereis_reverse)
			#t<< MenuAction.new( name: :whereis_next)
			#t<< MenuAction.new( name: :whereis_prev)

			self<< t
			#########################################################

			self<< Theme::Window::Main::Status.new( name: :status)

			vbox= Vbox.new( name: 'menu', :'.expand' => 'h')

			# Window menu:

			# Prepare these in advance. We can't just pass them as symbols
			# to m1.add_action() below as we need custom options here.
			m= Theme::MenuAction.new( name: 'main', hotkey: 'M')

			m1= Theme::Window::Main::Menu.new( name: :menu1, :'.display'=> 1)
			m1.add_action(
				m,
				:exit_help,
				:prevpage,
				# Note that this firstpage/lastpage won't actually execute their action,
				# since HOME/END are handled by textview itself and our main loop will
				# get an empty event. However, we add them here just so that they would
				# appear as available in the window menu.
				:firstpage,
				:'',
				:whereis_prev,
				:tablebr,
				:'',
				:quit,
				:nextpage,
				:lastpage,
				:whereis,
				:whereis_next
			)

			vbox<< m1

			self<< vbox
		end
	end
end
