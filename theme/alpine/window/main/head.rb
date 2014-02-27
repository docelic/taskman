module TASKMAN

	class Theme::Window::Main::Head < Hbox

		def initialize *arg
			super()

			@name= 'head'
			@variables['.expand']= 0

			self<< Label.new( :name => 'program_name_version', '.tie' => 'l', '.expand' => '0', :text => '  TASKMAN 0.01(26)    ')
			self<< Label.new( :name => 'program_location',     '.tie' => 'l',                   'text' => 'MAIN MENU')
			self<< Label.new(                                  '.tie' => 'r',                   :text => 'Folder: ')
			self<< Label.new( :name => 'folder_name',          '.tie' => 'l',                   'text' => 'INBOX')
			self<< Label.new( :name => 'folder_count',         '.tie' => 'r',                   'text' => 1)
			self<< Label.new( :name => 'folder_unit',          '.tie' => 'l', '.expand' => '0', 'text' => ' Items  ')
		end

	end

end
