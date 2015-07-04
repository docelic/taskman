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
			hk= Theme::MenuAction.new( name: 'hotkey_in', shortname: 'List Fldr')
			pu= Theme::MenuAction.new( name: 'pos_pgup', hotkey: '-')
			pd= Theme::MenuAction.new( name: 'pos_pgdown', hotkey: 'SPACE', hotkey_label: 'SPC')
			ph= Theme::MenuAction.new( name: 'pos_home', hotkey: nil)
			pe= Theme::MenuAction.new( name: 'pos_end', hotkey: nil)
			m1.add_action(
				:help,
				:hotkey_out,
				ph,
				pu,
				:add_folder,
				:rename_folder,
				:tablebr,
				:other,
				hk,
				pe,
				pd,
				:delete_folder,
				:whereis, #duplicate
			)

			m2= Theme::Window::Main::Menu.new(      arg.merge( name: :menu2, :'.display'=> 0))
			# Prepare some custom-named/shortnamed actions
			indx= Theme::MenuAction.new( name: 'index', shortname: 'CurIndex')

			m2.add_action(
				:help2,
				:quit,
				:goto_line,
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
