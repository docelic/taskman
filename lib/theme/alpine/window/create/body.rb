module TASKMAN

	class Theme::Window::Create::Body < Window

		def initialize arg= {}
			super

			@widget= nil
			i= arg[:id] ? $session.dbh.find( arg[:id]) : $session.dbh.new
			db= $session.dbn.to_s

			self<< MenuAction.new( name: :top_header)

			h= Hbox.new

			v= Vbox.new
			v<< Label.new(                    '.expand'=> 'h', )

#			h2= Hbox.new(                      '.expand'=> 'h')
#			h2<< Label.new(                    '.expand'=> '',  text: 'To      : ')
#			h2<< Input.new( name: :to, '.expand'=> 'h', text: '', tooltip: nil)
#			v<< h2
#
#			h2= Hbox.new(                     '.expand'=> 'h')
#			h2<< Label.new(                   '.expand'=> '',  text: 'Cc      : ')
#			h2<< Input.new( name: :cc, '.expand'=> 'h', text: '', tooltip: nil)
#			v<< h2

			h2= Hbox.new(                     '.expand'=> 'h', '.display'=> 0)
			h2<< Label.new(                   '.expand'=> '',  text: 'Task ID     : ')
			h2<< Input.new( name: :id,      '.expand'=> 'h', text: i.id, tooltip: nil)
			v<< h2
			h2= Hbox.new(                     '.expand'=> 'h', '.display'=> 0)
			h2<< Label.new(                   '.expand'=> '',  text: 'Task DB     : ')
			h2<< Input.new( name: :db,      '.expand'=> 'h', text: db, tooltip: nil)
			v<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Subject     : ')
			h2<< Input.new( name: :subject, '.expand'=> 'h', text: i._subject, tooltip: nil)
			v<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Category    : ')
			h2<< Input.new( name: :folder_names,   '.expand'=> 'h', text: i._folder_names, tooltip: nil)
			v<< h2

			# "Options" toggles

			#
			# TIMING
			#
			h2= Hbox.new(                     '.expand'=> '')
			c= Button.new( name: :timing,'.expand'=> '', value: 0, pos: 1, text_0: '> Timing Options ', text_1: '< Timing Options ', bind_toggle: '')
			c<< MenuAction.new( name: :toggle_timing_options)
			h2<< c
			h2<< Label.new(                   '.expand'=> 'h')
			v<< h2

			h3= Vbox.new( name: :timing_options, '.expand'=> '', '.display'=> 0)

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Start       : ')
			h2<< Input.new( name: :start  , '.expand'=> 'h', text: i._start, tooltip: 'Never alert or remind before this date, e.g. 2014-01-30 | 20140130 | 30th Dec 2014')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'End         : ')
			h2<< Input.new( name: :stop,    '.expand'=> 'h', text: i._stop, tooltip: 'Never alert or remind after this date, e.g. 2015-01-30 | 20150130 | 30th Jan 2015')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Time        : ')
			h2<< Input.new( name: :time_ssm,'.expand'=> 'h', text: i._time_ssm, tooltip: 'Time, e.g. 12:30 | 12:30:00 | -2:00 | -2:00:00')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Due dates   : ')
			h2<< Input.new( name: :due,     '.expand'=> 'h', text: i._due, tooltip: 'Due dates, e.g. 3 | -1 | 2012, 2013 | MON, TUE | JAN, FEB | 12..22(2) ...')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Omit dates  : ')
			h2<< Input.new( name: :omit,    '.expand'=> 'h', text: i._omit, tooltip: 'Omit dates, e.g. ... MON..FRI | JAN..DEC(2) | 2012..2014 | *+-aXb | >2014')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Omit shift  : ')
			h2<< Input.new( name: :omit_shift,'.expand'=> 'h', text: i._omit_shift, tooltip: 'Reschedule if omitted, e.g. 1 | 0 | -1')
			h3<< h2

			v<< h3

			#
			# REMIND
			#

			h2= Hbox.new(                     '.expand'=> '')
			c= Button.new( name: :reminding,'.expand'=> '', value: 0, pos: 1, text_0: '> Remind Options ', text_1: '< Remind Options ', bind_toggle: '')
			c<< MenuAction.new( name: :toggle_reminding_options)
			h2<< c
			h2<< Label.new(                   '.expand'=> 'h')
			v<< h2

			h3= Vbox.new( name: :reminding_options, '.expand'=> '', '.display'=> 0)

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Remind      : ')
			h2<< Input.new( name: :remind,  '.expand'=> 'h', text: i._remind, tooltip: 'Reminder, e.g. -90M*10Mx3 | Jan 1 2014 12:00 | 2014-01-01')
			h3<< h2

			h2= Hbox.new(                     '.expand'=> 'h')
			h2<< Label.new(                   '.expand'=> '',  text: 'Omit remind : ')
			h2<< Input.new( name: :omit_remind,    '.expand'=> 'h', text: i._omit_remind, tooltip: 'Omit remind if date omitted, e.g. 1 | 0')
			h3<< h2

			v<< h3

			v<< Label.new(                    '.expand'=> 'h', text: '----- Message Text -----')

			t= Textedit.new( name: :message, text: i._message, focus: 1)
			v<< t

			h<< v

			self<< h
		end

		def init arg= {}
			if arg[:open_timing]
				w= self.parent
				a= w['timing'].action
				if Symbol=== f= a.function
					a.send( f, window: self.parent, widget: arg[:widget], base_widget: arg[:base_widget], action: a, function: f, event: 'ENTER')
				elsif Proc=== f= a.function
					f.yield( window: self.parent, widget: c, base_widget: arg[:base_widget], action: a, function: f, event: 'ENTER')
				end
			end
			if arg[:open_reminding]
				w= self.parent
				a= w['reminding'].action
				if Symbol=== f= a.function
					a.send( f, window: self.parent, widget: arg[:widget], base_widget: arg[:base_widget], action: a, function: f, event: 'ENTER')
				elsif Proc=== f= a.function
					f.yield( window: self.parent, widget: c, base_widget: arg[:base_widget], action: a, function: f, event: 'ENTER')
				end
			end
			# On new tasks, we focus the first field (Subject)
			# On editing existing tasks, we focus the message field
			id= self['id'].var_text_now.to_i
			fw= $opts[ id> 0 ? 'focus-on-edit' : 'focus-on-create']
			fw2= self[fw] and fw2.set_focus
		end
	end
end
