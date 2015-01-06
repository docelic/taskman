# File implementing generic style functions.
# Append with your style definitions using --style NAME.
# Default: alpine style (style/alpine.rb)

module TASKMAN
	class Style
		@@Def= []

		def initialize arg= {}
			super()
			require File.join :style, arg[:style]
		end

		# Current approach where all style specs are iterated over,
		# in the order of definition.
		def specs
			@@Def
		end

		# Delete/clear all current styles. Useful in the colortest
		# window where we need to have no default style, or it
		# overwrites our colors.
		def clear
			@@Def= []
		end
	end
end
