module TASKMAN

	class Hspace < Label

		def initialize arg= {}
			arg[:'.expand']||= 'h'
			super
		end
	end
end
