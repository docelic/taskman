require 'theme/alpine/window'
require 'theme/alpine/window/main'
require 'theme/alpine/window/main/head'
require 'theme/alpine/window/main/body'
require 'theme/alpine/window/main/status'
require 'theme/alpine/window/main/menu'
require 'theme/alpine/menuaction'

module TASKMAN

	class Theme::Init < Object

		def initialize *arg
			super()

			$app.screen= Theme::Window::Main.new( :name => :main)
		end

	end

end
