module TASKMAN

	class Theme::Window::Index < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/index/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( arg.merge( name: :header, :title => _('TASK INDEX')))
			self<< @b= Theme::Window::Index::Body.new( arg.merge( name: :body))
			self<< Theme::Window::Main::Status.new( arg.merge( name: :status))

			m1= Theme::Window::Main::Menu.new(      arg.merge( name: :menu1))
			m1.add_action(
				:help,
				:'',
				:'', #prevmsg
				:'', #prevpage
				:delete_task, # Where to put mark as done
				:'', #edit
				:tablebr,
				:other, # O boy, there are some!
				:select_task, #hotkey in that goes to task
				:'', #nextmsg
				:'', #nextpage
				:undelete_task, # Where to put mark as not done
				:'', #duplicate
			)

			m2= Theme::Window::Main::Menu.new(      arg.merge( name: :menu2, :'.display'=> 0))
			m2.add_action(
				:help2,
				:mainc,
				:create,
				:'',
				:'',
				:'',
				:tablebr,
				:other2,
				:quit,
				:'', #nextmsg
				:'', #nextpage
				:'', #undelete (mark as not done?)
				:'', #duplicate
			)

			self<< m1
			self<< m2
		end
	end
end
