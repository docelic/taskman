require 'theme/alpine/mainwindow'
require 'theme/alpine/window'

require 'theme/alpine/head'
require 'theme/alpine/body'
require 'theme/alpine/status'
require 'theme/alpine/menu'
require 'theme/alpine/menuaction'

module TASKMAN

	class Theme::Init < Object

		def initialize *arg
			super()

			$app.screen= Theme::MainWindow.new( :name => :main)
		end

	end

end
