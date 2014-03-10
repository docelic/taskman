module TASKMAN

	class Theme::Window::Main::Menu < Menu

		def initialize *arg
			super

			@widget= :table
			@variables['.expand']= 'h'
			@variables['.height']= 1

			@page_size= 6
			@offset= 0
			@cols= 6
		end
	
	end

end
