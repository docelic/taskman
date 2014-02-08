require 'theme/alpine/window'

require 'theme/alpine/head'
require 'theme/alpine/body'
require 'theme/alpine/status'
require 'theme/alpine/menu'
require 'theme/alpine/menuaction'

module TASKMAN

	class Theme::Screen < Screen

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Head.new( :name => :head)
			self<< Theme::Body.new( :name => :body)
			self<< Theme::Status.new( :name => :status)
			self<< Theme::Menu.new( :name => :menu)

			@children_hash[:menu].add_action( :help, :quit)
		end

	end

end
