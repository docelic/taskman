module TASKMAN

	class Hspace < Label

		def initialize arg= {}
			super( { :'.expand'=> 'h'}.merge arg)
		end
	end
end
