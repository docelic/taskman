module TASKMAN

	class MenuAction < Widget
		
		@@Menus= {
			'test' => { 'hotkey' => 'T', 'description' => 'Test' },
		}

		def initialize name, *arg
			super *arg
		end

	end

end
