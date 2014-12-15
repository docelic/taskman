
module TASKMAN

	class Theme::Window::Create < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/create/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/create/menu'

		def initialize arg= {}
			super arg

			@widget= 'vbox'

			arg.merge!( :parent => self)

			self<< Theme::Window::Main::Header.new(   arg.merge( :name => :header, :title => 'CREATE TASK'))

			b= Theme::Window::Create::Body.new( arg.merge( :name => :body))
			self<< b
			b.init arg

			self<< Theme::Window::Main::Status.new( arg.merge( :name => :status))
			m1= Theme::Window::Create::Menu.new(    arg.merge( :name => :menu1))
			m1.add_action(
				:get_help,
				:create_task,
				:'',
				:'',
				:cut_line,
				:'',
				:tablebr,
				:cancel,
			)

			self<< m1
		end

	end

end
