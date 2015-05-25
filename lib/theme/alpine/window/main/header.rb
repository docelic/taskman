module TASKMAN

	class Theme::Window::Main < Theme::Window
		class Header < Hbox

			def initialize arg= {}
				super arg.merge( '.expand'=> '0')

				self<< Label.new( name: "#{@name}_program_name_version", '.tie'=> 'l', '.expand' => '0', text: "  TASKMAN #{$opts['version']}   ")
				self<< Label.new( name: "#{@name}_program_location",     '.tie'=> 'l',                   text: arg[:title])
				self<< Label.new( name: "#{@name}_label1",               '.tie'=> 'r',                   text: _('Folder: '))
				self<< Label.new( name: "#{@name}_folder_name",          '.tie'=> 'l',                   text: $session.folder_name)
				self<< Label.new( name: "#{@name}_label2",               '.tie'=> 'r', '.expand' => '0', text: _('Group: '))
				self<< Label.new( name: "#{@name}_status_group_name",    '.tie'=> 'l',                   text: $session.status_group_name)
				self<< Label.new( name: "#{@name}_folder_count",         '.tie'=> 'r',                   text: $session.sth.includes( :status).where( $session.where).count)
				self<< Label.new( name: "#{@name}_folder_unit",          '.tie'=> 'l', '.expand' => '0', text: " #{$session.sth.count.unit}  ")
			end
		end
	end
end
