module TASKMAN

	class Theme::Window::Main::Menu < Menu

		def initialize *arg
			super

			@widget= :table
			@variables['.expand']= 'h'
			@variables['.height']= 1
		end
	
	end

end
