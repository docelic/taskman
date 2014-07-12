module TASKMAN

	class Theme::Window::Colortest::Head < Theme::Window

		def initialize *arg
			super()

			h= Hbox.new(                                                   '.expand' => '0',                                 :@style_normal => 'bg=white,fg=black')
			h<< Label.new( :name => 'program_name_version', '.tie' => 'l', '.expand' => '0', :text => $opts['version_string'])
			h<< Label.new( :name => 'program_location',     '.tie' => 'l',                   'text' => 'MAIN MENU')
			h<< Label.new(                                  '.tie' => 'r',                   :text => 'Folder: ')
			h<< Label.new( :name => 'folder_name',          '.tie' => 'l',                   'text' => 'INBOX')
			h<< Label.new( :name => 'folder_count',         '.tie' => 'r',                   'text' => 1)
			h<< Label.new( :name => 'folder_unit',          '.tie' => 'l', '.expand' => '0', 'text' => ' Items  ')

			self<< h
		end

	end

end
