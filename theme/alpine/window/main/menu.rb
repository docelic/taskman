module TASKMAN

	class Theme::Window::Main::Menu < Menu

		def initialize arg= {}
			super arg.merge( :'.expand'=> 'h', :'.height'=> 1)
			@widget= :table
		end
	end
end
