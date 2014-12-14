# File implementing generic style functions.
# Append with your style definitions using --style NAME.
# Default: alpine style (style/alpine.rb)

module TASKMAN
	class Style < Object
		@@Def= {}

		def initialize arg= {}
			super()
			return if arg[:style]=~ /^none$/i
			require File.join :style, arg[:style]
		end

		def [] arg
			@@Def[arg]
		end
	end
end
