require 'theme/alpine/window'

require 'theme/alpine/window/main'
require 'theme/alpine/window/main/head'
require 'theme/alpine/window/main/body'
require 'theme/alpine/window/main/status'
require 'theme/alpine/window/main/menu'

require 'theme/alpine/window/create'
require 'theme/alpine/window/create/head'
require 'theme/alpine/window/create/body'
require 'theme/alpine/window/create/status'
require 'theme/alpine/window/create/menu'

require 'theme/alpine/window/colortest'
require 'theme/alpine/window/colortest/head'
require 'theme/alpine/window/colortest/body'
require 'theme/alpine/window/colortest/status'
require 'theme/alpine/window/colortest/menu'

require 'theme/alpine/menuaction'

module TASKMAN

	class Theme::Init < Object

		attr_reader :style

		def initialize *arg
			super()

			@style= {}
		end

	end

end
