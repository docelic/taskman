module TASKMAN

	class Theme::Window::Colortest < Theme::Window
		require 'theme/alpine/window/main/header'
		require 'theme/alpine/window/colortest/body'
		require 'theme/alpine/window/main/status'
		require 'theme/alpine/window/colortest/menu'

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Header.new( :name => :header, :title => 'COLOR TEST')
			self<< Theme::Window::Colortest::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)
			self<< Theme::Window::Colortest::Menu.new( :name => :menu)
			@widgets_hash['menu'].add_action(
				:help,
				:'',
				#:back,
				:'',
				:'',
				:'',
				:'',
				:quit,
			)
		end

	end

end
