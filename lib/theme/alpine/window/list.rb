module TASKMAN

	class Theme::Window::List < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/list/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( arg.merge( :name=> :header, :title => _('FOLDER LIST')))
			self<< Theme::Window::List::Body.new(  arg.merge( :name=> :body))
			self<< Theme::Window::Main::Status.new( arg.merge( :name=> :status))

			m1= Theme::Window::Main::Menu.new(      arg.merge( :name=> :menu1))
			m1.add_action(
				:help,
				:mainc, # But on <
				:'', #prev fldr
				:'', #prev page
				:'', #delete (mark as done?)
				:'', #edit
				:tablebr,
				:'', #other
				:'', # Select/goto folder
				:'', #nextmsg
				:'', #nextpage
				:'', #undelete (mark as not done?)
				:'', #duplicate
			)

			#m2= Theme::Window::Main::Menu.new(      arg.merge( :name=> :menu2, :'.display'=> 0))
			#m2.add_action(
			#	:help2,
			#	:quit,
			#	:'',
			#	:'',
			#	:'',
			#	:'',
			#	:tablebr,
			#	:other2,
			#	:mainc,
			#	:'', #nextmsg
			#	:'', #nextpage
			#	:'', #undelete (mark as not done?)
			#	:'', #duplicate
			#)

			self<< m1
			#self<< m2
		end
	end
end
