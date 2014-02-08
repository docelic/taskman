#!/usr/bin/env ruby

$:.unshift File.dirname $0

require 'extensions'

require 'stfl_base'

require 'terminal'
require 'screen'
require 'window'

require 'layout'
require 'layout/vbox'
require 'layout/hbox'
require 'layout/table'

require 'widget'
require 'widget/label'
require 'widget/menuaction'
require 'widget/list'

require 'theme'
require 'menu'

module TASKMAN

	class Application < Object

		attr_reader :screen
		attr_accessor :stfl

		def initialize *arg
			super()
		end

		def start
			exec
		end

		def exec
			theme = 'alpine'
			require File.join :theme, theme, :screen

			@screen= Theme::Screen.new
			@screen.show

			@screen.main_loop
		end

	end

end

$app= TASKMAN::Application.new ARGV

if __FILE__== $0
	$app.start
end
