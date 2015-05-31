module TASKMAN

	class Theme::Window::Index < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/index/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		attr_accessor :folder

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( arg.merge( name: :header, :title => _('TASK INDEX')))
			self<< @b= Theme::Window::Index::Body.new( arg.merge( name: :body))
			self<< Theme::Window::Main::Status.new( arg.merge( name: :status))

			vbox= Vbox.new( name: 'menu', :'.expand' => 'h')

			m1= Theme::Window::Main::Menu.new(      arg.merge( name: :menu1))
			pu= Theme::MenuAction.new( name: 'pos_pgup', hotkey: '-')
			pd= Theme::MenuAction.new( name: 'pos_pgdown', hotkey: 'SPACE', hotkey_label: 'SPC')
			ph= Theme::MenuAction.new( name: 'pos_home', hotkey: nil)
			pe= Theme::MenuAction.new( name: 'pos_end', hotkey: nil)
			m1.add_action(
				:get_help,
				:listfolders,
				:sortby,
				:set_priority, #'', #edit
				:delete_task, # Where to put mark as done
				pu,
				:tablebr,
				:other, # O boy, there are some!
				:hotkey_in, #hotkey in that goes to task
				:show_group, #'', #nextmsg:'', #prevmsg
				:set_status,
				:undelete_task, # Where to put mark as not done
				pd,
			)

			m2= Theme::Window::Main::Menu.new(      arg.merge( name: :menu2, :'.display'=> 0))
			m2.add_action(
				:get_help2,
				:mainm,
				:create,
				:'',
				:whereis_prev,
				ph,
				:tablebr,
				:other2,
				:quit,
				:goto_line,
				:whereis,
				:whereis_next,
				pe,
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
