# File implementing generic style functions.
# Append with your style definitions using --style NAME.
# Default: alpine style (style/alpine.rb)

module TASKMAN
	class Style < Object
		@@Def= []
		@@Def_hash= {}

		def initialize arg= {}
			super()
			require File.join :style, arg[:style]

			# Accessing styles via specific name (through a hash) is 
			# here mainly for compatibility with old access method.
			# The new method iterates over styles being an array, and
			# handles symbols, regexes and procs in order as specified,
			# first match winning.
			@@Def.each{ |selector, spec|
				@@Def_hash[selector]= spec
      }
		end

		# As mentioned, obsolete approach
		def [] arg
			@@Def_hash[arg]
		end

		# Current approach where all style specs are iterated over,
		# in the order of definition.
		def specs
			@@Def
		end
	end
end