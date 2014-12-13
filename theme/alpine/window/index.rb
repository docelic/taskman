module TASKMAN

	class Theme::Window::Index < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Head.new( :name => :head, :title => 'TASK INDEX')
			self<< Theme::Window::Index::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)
			m1= Theme::Window::Index::Menu.new( :name => :menu)
			m1.add_action(
				:select_task
			)

			self<< m1
		end

	end

end
