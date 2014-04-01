# File implementing generic theme functions.

module TASKMAN

	class Theme < Object

		attr_reader :init

		def initialize arg= {}
			super()

			require File.join :theme, arg[:theme], :init

			@init||= Theme::Init.new

			wname= arg[:window] ? arg[:window] : $opts['window']
			window= ( 'TASKMAN::Theme::Window::'+ wname.ucfirst).to_class
			$app.screen= window.new( :name => wname)
		end

	end

end
