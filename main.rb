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
require 'widget/list'

require 'menu'
require 'menu/menuaction'

require 'theme'

module TASKMAN

	class Application < Object

		attr_reader :theme
		attr_accessor :screen, :ui

		def initialize *arg
			super()
		end

		def start
			exec
		end

		def exec
			@theme= Theme.new

			@ui= @screen.create

			@screen.main_loop
		end

	end

end

$app= TASKMAN::Application.new ARGV

if __FILE__== $0
	$app.start
end
