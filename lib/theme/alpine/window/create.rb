module TASKMAN

	class Theme::Window::Create < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/create/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new(       arg.merge( name: :header, title: ( arg[:title]|| _('CREATE TASK'))))
			self<< ( @b= Theme::Window::Create::Body.new( arg.merge( name: :body)))
			self<< Theme::Window::Main::Status.new(       arg.merge( name: :status))

			m1= Theme::Window::Main::Menu.new(            arg.merge( name: :menu1))
			m1.add_action(
				:get_help,
				( arg[:id] ? :save_task : :create_task),
				:'',
				:'',
				:'', #:cut_line,
				:'',
				:tablebr,
				:cancel,
				( arg[:id] ? :clone_task : :''),
				:'',
				:'',
				:'',
				:to_index,
			)

			self<< m1
		end

		def init arg= {}
			@b.init arg
		end
	end
end
