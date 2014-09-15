module TASKMAN

	class Theme::Window::Main::Head < Hbox

		def initialize arg= {}
			super()

			@name= arg.has_key?( :name) ? arg.delete( :name).to_s : 'head'
			@title= arg.has_key?( :title) ? arg.delete( :title).to_s : 'MAIN MENU'
			@variables['.expand']= 0

			self<< Label.new( :name => 'program_name_version', '.tie' => 'l', '.expand' => '0', :text => "   TASKMAN #{$opts['version']}   ")
			self<< Label.new( :name => 'program_location',     '.tie' => 'l',                   'text'=> @title)
			self<< Label.new(                                  '.tie' => 'r',                   :text => 'Folder: ')
			self<< Label.new( :name => 'folder_name',          '.tie' => 'l',                   'text'=> ($opts['folder'] == true ? 'ALL' : $opts['folder']))
			self<< Label.new( :name => 'folder_count',         '.tie' => 'r',                   'text'=> 1)
			self<< Label.new( :name => 'folder_unit',          '.tie' => 'l', '.expand' => '0', 'text'=> " #{1.unit}  ")
		end

	end

end
