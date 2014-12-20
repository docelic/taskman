module TASKMAN

	class Theme::Window::Colortest < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/colortest/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/main/menu'

		def initialize arg= {}
			super
			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new(    arg.merge( :name=> :header, :title=> _('COLOR TEST')))
			self<< Theme::Window::Colortest::Body.new( arg.merge( :name=> :body))
			self<< Theme::Window::Main::Status.new(    arg.merge( :name=> :status))

			m1= Theme::Window::Main::Menu.new(         arg.merge( :name=> :menu1))
			m1.add_action(
				:help,
				:quit,
				:'',
				:'',
				:'',
				:'',
				:tablebr,
				:'',
				:'',
				:'',
				:'',
				:'',
				:'',
			)

			self<< m1
		end
	end
end
