require 'theme/alpine/window'
require 'theme/alpine/body'
require 'theme/alpine/head'
require 'theme/alpine/status'
require 'theme/alpine/menuaction'
require 'theme/alpine/menu'
require 'theme/alpine/screen'

module TASKMAN

	class Theme::Init < Object

		def initialize *arg
			super

			$app.screen= Theme::Screen.new

		end

	end

end
