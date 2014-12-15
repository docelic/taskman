module TASKMAN

	class Hspace < Label

		def initialize arg= {}
			super arg.merge( :'.expand'=> 'h')
		end

	end

end
