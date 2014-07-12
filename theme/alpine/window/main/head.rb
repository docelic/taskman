module TASKMAN

	class Theme::Window::Main::Head < Hbox

		def initialize *arg
			super()

			@name= 'head'
			@variables['.expand']= 0

			self<< Label.new( :name => 'program_name_version', '.tie' => 'l', '.expand' => '0', :text => $opts['version_string'])
			self<< Label.new( :name => 'program_location',     '.tie' => 'l',                   'text' => 'MAIN MENU')
			self<< Label.new(                                  '.tie' => 'r',                   :text => 'Folder: ')
			self<< Label.new( :name => 'folder_name',          '.tie' => 'l',                   'text' => ($opts['folder'] == true ? 'ALL' : $opts['folder']))
			self<< Label.new( :name => 'folder_count',         '.tie' => 'r',                   'text' => 1)
			self<< Label.new( :name => 'folder_unit',          '.tie' => 'l', '.expand' => '0', 'text' => " #{1.unit}  ")
		end

	end

end
