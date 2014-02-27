module TASKMAN

	class Theme::Window::Create::Body < Window

		def initialize *arg
			super()

			@widget= nil

			h= Hbox.new

			v= Vbox.new
			v<< Label.new(                    '.expand' => 'h', )

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new( :name => :subject, '.expand' => '',  :text => 'Subject : ')
			h2<< Input.new( :name => :subject, '.expand' => 'h', :text => '')
			v<< h2

			v<< Label.new(                    '.expand' => 'h', )
			v<< Label.new(                    '.expand' => 'h', )
			v<< Label.new(                    '.expand' => 'h', )
			v<< Label.new(                    '.expand' => 'h', :text => '----- Message Text -----')

			h<< v
			self<< h
		end

	end

end
