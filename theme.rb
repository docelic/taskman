# File implementing generic theme functions.

module TASKMAN

	class Theme < Object

		def initialize *arg
			super

			theme = 'alpine'
			require File.join :theme, theme, :init

			@init= Theme::Init.new
		end

	end

end
