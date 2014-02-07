#!/usr/bin/env ruby

require 'stfl'

$:.unshift File.dirname $0

require 'extensions'

require 'stfl_base'

require 'layout'
require 'layout/vbox'
require 'layout/hbox'
require 'layout/table'

require 'widget'
require 'widget/label'
require 'widget/menuaction'

require 'window'

theme = 'alpine'
colorscheme = 'default'

require File.join :theme, theme, :mainwindow

module TASKMAN

	class Application < Object

		def initialize *arg
			super()
		end

		def layout
			return @layout if @layout

			@layout= Vbox.new

			@layout
		end

		def start
			exec
		end

		def exec
			w= MainWindow.new

			stfl_text=  w.to_stfl
			$stfl= Stfl.create stfl_text

			w.apply_menu

			if $stfl
				loop do
					event = $stfl.run(0)
					focus = $stfl.get_focus
					#pfl w.actions
					#pfl :EVENT_IS, event.to_s
					if w.actions.has_key? event
						w.actions[event].yield( event)
					end
				end
			else
				pfl w
			end
		end
	end

end

app= TASKMAN::Application.new ARGV

if __FILE__== $0
	app.start
end
