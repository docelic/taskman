#!/usr/bin/env ruby

require 'stfl'

$:.unshift File.dirname $0

require 'extensions'
require 'stfl_base'

require 'layout'
require 'vbox'
require 'hbox'

require 'widget'
require 'label'

require 'mainwindow'

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
			stfl= nil
			stfl= Stfl.create w.to_s

			if stfl
				loop do
					event = stfl.run(0)
					focus = stfl.get_focus
					Stfl.set( stfl, 'folder_count', '9')
					pfl :IN
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

