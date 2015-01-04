module TASKMAN

	class Theme::Window::Main::Menu < Menu

		def initialize arg= {}
			super( { :'.expand'=> 'h', :'.height'=> 1}.merge arg)
			@widget= :table
		end
	end
end
