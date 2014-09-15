module TASKMAN

	class Theme::Window::Create::Body < Window

		def initialize *arg
			super()

			@widget= nil

			self<< MenuAction.new( :name => :top_header)

			h= Hbox.new

			v= Vbox.new
			v<< Label.new(                     '.expand' => 'h', )

#			h2= Hbox.new(                      '.expand' => 'h')
#			h2<< Label.new(                    '.expand' => '',  :text => 'To      : ')
#			h2<< Input.new( :name => :to, '.expand' => 'h', :text => '', :tooltip => nil)
#			v<< h2
#
#			h2= Hbox.new(                      '.expand' => 'h')
#			h2<< Label.new(                    '.expand' => '',  :text => 'Cc      : ')
#			h2<< Input.new( :name => :cc, '.expand' => 'h', :text => '', :tooltip => nil)
#			v<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Subject     : ')
			h2<< Input.new( :name => :subject, '.expand' => 'h', :text => '', :tooltip => nil)
			v<< h2

			# "Options" toggles

			#
			# TIMING
			#
			h2= Hbox.new(                      '.expand' => '')
			c= Checkbox.new( :name => :timing,'.expand' => '', :value => 0, :pos => 1, :text_0 => '> Timing Options ', :text_1 => '< Timing Options ', :bind_toggle => '', :style_focus => 'fg=black,bg=white')
			c<< MenuAction.new( :name => :toggle_timing_options)
			h2<< c
			h2<< Label.new(                    '.expand' => 'h')
			v<< h2

			h3= Vbox.new( :name => :timing_options, '.expand' => '', '.display' => 0)

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Start       : ')
			h2<< Input.new( :name => :start  , '.expand' => 'h', :text => '', :tooltip => 'Never alert or remind before this date, e.g. 2014-01-30 | 20140130 | 30th Dec 2014')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'End         : ')
			h2<< Input.new( :name => :end,     '.expand' => 'h', :text => '', :tooltip => 'Never alert or remind after this date, e.g. 2015-01-30 | 20150130 | 30th Jan 2015')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Time        : ')
			h2<< Input.new( :name => :time,    '.expand' => 'h', :text => '', :tooltip => 'Time, e.g. 12:30 | 12:30:00 | -2:00 | -2:00:00')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Due dates   : ')
			h2<< Input.new( :name => :due,     '.expand' => 'h', :text => '', :tooltip => 'Due dates, e.g. 3 | -1 | 2012, 2013 | MON, TUE | JAN, FEB | 12..22(2) ...') #, MON..FRI, JAN..DEC(2), 2012..2014, *+-aXb, >2014')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit dates  : ')
			h2<< Input.new( :name => :omit,    '.expand' => 'h', :text => '', :tooltip => 'Omit dates, e.g. ... MON..FRI | JAN..DEC(2) | 2012..2014 | *+-aXb | >2014')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit shift  : ')
			h2<< Input.new( :name => :omit_shift,    '.expand' => 'h', :text => '', :tooltip => 'Reschedule if omitted, e.g. 1 | -1')
			h3<< h2

			v<< h3

			#
			# REMIND
			#

			h2= Hbox.new(                      '.expand' => '')
			c= Checkbox.new( :name => :remind,'.expand' => '', :value => 0, :pos => 1, :text_0 => '> Remind Options ', :text_1 => '< Remind Options ', :bind_toggle => '', :style_focus => 'fg=black,bg=white')
			c<< MenuAction.new( :name => :toggle_remind_options)
			h2<< c
			h2<< Label.new(                    '.expand' => 'h')
			v<< h2

			h3= Vbox.new( :name => :remind_options, '.expand' => '', '.display' => 0)

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Remind      : ')
			h2<< Input.new( :name => :remind_spec,  '.expand' => 'h', :text => '', :tooltip => 'Reminder, e.g. -90M*10Mx3 | Jan 1 2014 12:00 | 2014-01-01 | 20140101')
			h3<< h2

			h2= Hbox.new(                      '.expand' => 'h')
			h2<< Label.new(                    '.expand' => '',  :text => 'Omit remind : ')
			h2<< Input.new( :name => :remind_shift,    '.expand' => 'h', :text => '', :tooltip => 'Omit remind if date omitted, e.g. 1 | t | true | 0 | f | false')
			h3<< h2

			v<< h3

			v<< Label.new(                     '.expand' => 'h', :text => '----- Message Text -----')

			t= Textedit.new( :name => :message)
			t<< ListItem.new
			v<< t

			h<< v
			self<< h
		end

	end

end
