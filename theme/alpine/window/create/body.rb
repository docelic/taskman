module TASKMAN

	class Theme::Window::Create::Body < Window

		def initialize *arg
			super()

			@widget= nil

			h= Hbox.new

			v= Vbox.new
			v<< Label.new(                     '.expand' => 'h', )

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Subject     : ')
			h2<< Input.new( :name => :subject, '.expand' => 'h', :text => '', :tooltip => 'Task name / short description')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Start       : ')
			h2<< Input.new( :name => :start  , '.expand' => 'h', :text => '', :tooltip => 'Never alert or remind before this date, e.g. 2014-01-01 | 20140101 | 1st Jan 2014')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'End         : ')
			h2<< Input.new( :name => :end,     '.expand' => 'h', :text => '', :tooltip => 'Never alert or remind after this date, e.g. 2015-01-01 | 20150101 | 1st Jan 2015')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Time        : ')
			h2<< Input.new( :name => :time,    '.expand' => 'h', :text => '', :tooltip => 'Time, e.g. 12:30 | 12:30:00 | -2:00 | -2:00:00')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Due dates   : ')
			h2<< Input.new( :name => :due,     '.expand' => 'h', :text => '', :tooltip => 'Due dates, e.g. 3 | -1 | 2012, 2013 | MON, TUE | JAN, FEB | 12..22(2) ...') #, MON..FRI, JAN..DEC(2), 2012..2014, *+-aXb, >2014')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit dates  : ')
			h2<< Input.new( :name => :omit,    '.expand' => 'h', :text => '', :tooltip => 'Omit dates, e.g. ... MON..FRI | JAN..DEC(2) | 2012..2014 | *+-aXb | >2014')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit shift  : ')
			h2<< Input.new( :name => :omit_shift,    '.expand' => 'h', :text => '', :tooltip => 'Reschedule if omitted, e.g. 1 | -1')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Remind      : ')
			h2<< Input.new( :name => :remind,  '.expand' => 'h', :text => '', :tooltip => 'Reminder, e.g. -90M*10Mx3 | Jan 1 2014 12:00 | 2014-01-01 | 20140101')
			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit remind : ')
			h2<< Input.new( :name => :remind_shift,    '.expand' => 'h', :text => '', :tooltip => 'Omit remind if date omitted, e.g. 1 | t | true | 0 | f | false')
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
