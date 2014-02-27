# File implementing generic theme functions.

module TASKMAN

	class Theme < Object

		attr_reader :init

		def initialize arg
			super()

			require File.join :theme, arg[:theme], :init

			@init= Theme::Init.new

			window= ( 'TASKMAN::Theme::Window::'+ $opts['window'].ucfirst).to_class
			$app.screen= window.new( :name => $opts['window'])
		end

	end

end
