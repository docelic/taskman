module TASKMAN

	class Vspace < Label

		def initialize arg= {}
			arg[:'.expand']||= 'v'
			super
		end
	end
end
