module TASKMAN

	class Theme::Window::Main
		class Header < Hbox

			def initialize arg= {}
				super

				@title= arg[:title].to_s|| 'MAIN MENU'
				@variables['.expand']= 0

				self<< Label.new( :name=> "#{@name}_program_name_version", '.tie' => 'l', '.expand' => '0', :text => "  TASKMAN #{$opts['version']}  ")
				self<< Label.new( :name=> "#{@name}_program_location",     '.tie' => 'l',                   'text'=> @title)
				self<< Label.new( :name=> "#{@name}_label1",               '.tie' => 'r',                   :text => 'Folder: ')
				self<< Label.new( :name=> "#{@name}_folder_name",          '.tie' => 'l',                   'text'=> ($opts['folder'] == true ? 'ALL' : $opts['folder']))
				self<< Label.new( :name=> "#{@name}_folder_count",         '.tie' => 'r',                   'text'=> $tasklist[:tasks].keys.count)
				self<< Label.new( :name=> "#{@name}_folder_unit",          '.tie' => 'l', '.expand' => '0', 'text'=> " #{$tasklist[:tasks].keys.count.unit}  ")
			end

		end

	end

end
