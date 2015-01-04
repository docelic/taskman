module TASKMAN

	class Vspace < Label

		def initialize arg= {}
			super( { :'.expand'=> 'v'}.merge arg)
		end
	end
end
