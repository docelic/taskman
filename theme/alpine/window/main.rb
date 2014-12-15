module TASKMAN

	class Theme::Window::Main < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/main/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( arg.merge( :name=> :header, :title => _('MAIN MENU')))
			self<< Theme::Window::Main::Body.new(   arg.merge( :name=> :body))
			self<< Theme::Window::Main::Status.new( arg.merge( :name=> :status))


			m1= Theme::Window::Main::Menu.new(      arg.merge( :name=> :menu1))
			m1.add_action(
				:help,
				:create,
				:prevcmd2,
				:listfolders,
				:index,
				:'',
				:tablebr,
				:quit,
				:hotkey_in,
				:nextcmd2,
				:gotofolder,
			)

#			m2= Theme::Window::Main::Menu.new( :name=> :menu2, :'.display'=> 0)
#			m2.add_action(
#				:'', #:help2,
#				:'', #:setup
#				:'', #:role,
#				:tablebr, ##
#				:other2,
#				:'', #:journal,
#				:'', #:addrbook,
#				:'',
#			)

			self<< m1
#			self<< m2
		end
	end
end
