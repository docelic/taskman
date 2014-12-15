module TASKMAN

	class Vspace < Label

		def initialize arg= {}
			super arg.merge!( :expand => 'v')
		end

	end

end
