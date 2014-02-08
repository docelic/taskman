require 'theme/alpine/window'

require 'theme/alpine/head'
require 'theme/alpine/body'
require 'theme/alpine/status'
require 'theme/alpine/menu'

module TASKMAN

	class Theme::Screen < Screen

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Head.new
			self<< Theme::Body.new
			self<< Theme::Status.new
			self<< Theme::Menu.new( :help)

		end

	end

end
