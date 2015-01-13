module TASKMAN

	class Theme::Window::List < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/list/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( arg.merge( name: :header, :title => _('FOLDER LIST')))
			self<< @b= Theme::Window::List::Body.new(  arg.merge( name: :body))
			self<< Theme::Window::Main::Status.new( arg.merge( name: :status))

			vbox= Vbox.new( name: 'menu', :'.expand' => 'h')

			m1= Theme::Window::Main::Menu.new(      arg.merge( name: :menu1))
			m1.add_action(
				:help,
				:mainlt,
				:'', #prev fldr
				:'', #prev page
				:add_folder,
				:'', #edit
				:tablebr,
				:other,
				:'', #:quit, # Select/goto folder
				:'', #nextmsg
				:'', #nextpage
				:delete_folder,
				:whereis, #duplicate
			)

			m2= Theme::Window::Main::Menu.new(      arg.merge( name: :menu2, :'.display'=> 0))
			# Prepare some custom-named/shortnamed actions
			indx= Theme::MenuAction.new( name: 'index', shortname: 'CurIndex')

			m2.add_action(
				:help2,
				:quit,
				:'',
				indx,
				:'',
				:'',
				:tablebr,
				:other2,
				:mainm,
				:'', #nextmsg
				:'', #nextpage
				:'', #undelete (mark as not done?)
				:'', #duplicate
			)

			vbox<< m1
			vbox<< m2

			self<< vbox
		end

		def init arg= {}
			super
			@b.init arg
		end
	end
end
