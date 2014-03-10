module TASKMAN

	class Theme::Window::Create::Body < Window

		def initialize *arg
			super()

			@widget= nil

			h= Hbox.new

			v= Vbox.new
			v<< Label.new(                    '.expand' => 'h', )

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Subject : ')
			h2<< Input.new( :name => :subject, '.expand' => 'h', :text => '')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Start   : ')
			h2<< Input.new( :name => :start  , '.expand' => 'h', :text => '')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'End     : ')
			h2<< Input.new( :name => :end,     '.expand' => 'h', :text => '')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Due     : ')
			h2<< Input.new( :name => :due,     '.expand' => 'h', :text => '')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Remind  : ')
			h2<< Input.new( :name => :remind,  '.expand' => 'h', :text => '')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Time    : ')
			h2<< Input.new( :name => :time,    '.expand' => 'h', :text => '')
			v<< h2

			v<< Label.new(                     '.expand' => 'h', :text => '----- Message Text -----')

			t= Textedit.new( :name => :message)
			t<< ListItem.new

			v<< t

			h<< v
			self<< h
		end

	end

end
