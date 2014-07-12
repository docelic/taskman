require 'theme/alpine/window'

module TASKMAN

	class Theme::Window::Colortest::Status < Theme::Window

		def initialize *arg
			super()

			s= Hbox.new(                      '.expand' => 'h', :@style_normal => 'bg=red,fg=white')
			s<< Label.new(                    '.expand' => '0', :@style_normal => 'bg=blue,fg=white',  :text => ' ')
			s<< Label.new(                                      :@style_normal => 'bg=black,fg=white', :text => '')
			s<< Label.new( :name => 'status', '.expand' => '0', :@style_normal => 'bg=blue,fg=white',  :text => '')
			s<< Label.new(                                      :@style_normal => 'bg=black,fg=white', :text => '')

			self<< s

		end

	end

end
