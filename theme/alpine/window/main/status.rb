require 'theme/alpine/window'

module TASKMAN

	class Theme::Window::Main::Status < Hbox

		def initialize *arg
			super

			@variables['.expand']= 'h'

			self<< Label.new( :name=> "#{@name}_space1", '.expand'=> '0', :text=> ' ')
			self<< Label.new( :name=> "#{@name}_space2",                  :text=> '')
			self<< Label.new( :name=> "#{@name}_label",  '.expand'=> '0', :text=> '')
			self<< Label.new( :name=> "#{@name}_space3",                  :text=> '')
		end

	end

end
