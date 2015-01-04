# File implementing generic theme functions.

module TASKMAN

	class Theme

		attr_reader :init

		def initialize arg= {}
			super()

			require File.join :theme, arg[:theme], :init

			@init||= Theme::Init.new

			wname= arg[:window] ? arg[:window] : $opts['window']

			mf= 'theme/'+ $opts['theme']+ '/window/'+ wname
			require mf

			window= ( 'TASKMAN::Theme::Window::'+ wname.ucfirst).to_class
			arg[:name]= wname
			$app.screen= window.new arg
		end

	end

end
