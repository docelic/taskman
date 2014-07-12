module TASKMAN

	class Theme::Window::Create < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Head.new( :name => :head)
			self<< Theme::Window::Create::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)
			m1= Theme::Window::Create::Menu.new( :name => :menu)
			m1.add_action(
				:create_task
			)

			self<< m1
		end

	end

end
