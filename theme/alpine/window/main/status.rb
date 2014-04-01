require 'theme/alpine/window'

module TASKMAN

	class Theme::Window::Main::Status < Hbox

		def initialize *arg
			super()

			@variables['.expand']= 'h'

			s= Hbox.new(                      '.expand' => 'h')
			s<< Label.new(                    '.expand' => '0', :text => ' ')
			s<< Label.new(                                      :text => '')
			s<< Label.new( :name => 'status', '.expand' => '0', :text => '')
			s<< Label.new(                                      :text => '')

			self<< s
		end

	end

end
