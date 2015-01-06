module TASKMAN

	class Theme::Window::Main < Theme::Window
		class Header < Hbox

			def initialize arg= {}
				super arg.merge( '.expand'=> '0')

				if c= $session.category
					folder= c.name
					obj= c.items
				else
					folder= 'ALL'
					obj= Item.all
				end

				self<< Label.new( name: "#{@name}_program_name_version", '.tie'=> 'l', '.expand' => '0', text: "  TASKMAN #{$opts['version']}   ")
				self<< Label.new( name: "#{@name}_program_location",     '.tie'=> 'l',                   text: arg[:title])
				self<< Label.new( name: "#{@name}_label1",               '.tie'=> 'r',                   text: 'Folder: ')
				self<< Label.new( name: "#{@name}_folder_name",          '.tie'=> 'l',                   text: folder)
				self<< Label.new( name: "#{@name}_folder_count",         '.tie'=> 'r',                   text: obj.count)
				self<< Label.new( name: "#{@name}_folder_unit",          '.tie'=> 'l', '.expand' => '0', text: " #{obj.count.unit}  ")
			end
		end
	end
end
