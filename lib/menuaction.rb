module TASKMAN

	class MenuAction < Widget
		
		# TODO move this to outside file
		@@Menus= {
			# To have multiple "same" menus, you must use different names
			'help'      => { hotkey: '?',   shortname: 'Help',        menuname: 'Help',        description: 'Get help using Taskman', function: :help},
			'help2'     => { hotkey: nil, hotkey_label: '?',  shortname: 'Help',        menuname: 'Help',        description: 'Get help using Taskman', function: nil},
			'get_help'  => { hotkey: 'H',  shortname: 'Get Help',    menuname: 'Get Help',    description: 'Get help',               function: :help},
			'get_help2' => { hotkey: nil, hotkey_label: 'H', shortname: 'Get Help',    menuname: 'Get Help',    description: 'Get help',               function: :help},
			'exit_help' => { hotkey: 'E',   shortname: 'Exit Help',   menuname: 'Exit Help',   description: 'Exit Help', function: :prev_window },

			# For the empty slot, no need to use a different name even if it appears multiple times, because empty name results in the name being auto-generated
			''          => { hotkey: '',    shortname: '',            menuname: '',            description: '', function: nil }, # Empty one

			# The current useful bulk of our actions
			'hotkey_in' => { hotkey: '>',   shortname: '',            menuname: '',            description: '', function: nil },

			'nextcmd2'  => { hotkey: 'N',   shortname: 'NextCmd',     menuname: 'NextCmd',     description: '', function: :nextcmd2 },
			'prevcmd2'  => { hotkey: 'P',   shortname: 'PrevCmd',     menuname: 'PrevCmd',     description: '', function: :prevcmd2 },
			'firstpage' => { hotkey: 'HOME',shortname: 'FirstPage',   menuname: 'FirstPage',   description: '', function: :firstpage },
			'lastpage'  => { hotkey: 'END', shortname: 'LastPage',    menuname: 'LastPage',    description: '', function: :lastpage },
			'nextpage'  => { hotkey: 'SPACE', hotkey_label: 'SPC', shortname: 'NextPage',   menuname: 'NextPage',    description: '', function: :nextpage },
			'prevpage'  => { hotkey: '-',   shortname: 'PrevPage',    menuname: 'PrevPage',    description: '', function: :prevpage },

			'main'      => { hotkey: '^M',  shortname: 'Main Menu',   menuname: 'Main Menu',   description: 'Main Menu', function: :main },
			'main2'     => { hotkey: nil, hotkey_label: '^M', shortname: 'Main Menu',   menuname: 'Main Menu',   description: 'Main Menu', function: nil },
			'mainlt'     => { hotkey: '<',   shortname: 'Main Menu',   menuname: 'Main Menu',   description: 'Main Menu', function: :main },
			'mainm'     => { hotkey: 'M',   shortname: 'Main Menu',   menuname: 'Main Menu',   description: 'Main Menu', function: :main },

			'create'    => { hotkey: 'C',   shortname: 'Create',      menuname: 'Create Task', description: 'Create a task', function: :create },
			'index'     => { hotkey: 'I',   shortname: 'Index',       menuname: 'Task Index',  description: 'View tasks in current folder', function: :index },
			'to_index'  => { hotkey: '^T',  shortname: 'To Index',    menuname: 'Task Index',    description: 'View tasks in current folder', function: :index },

			'create_task'=>{ hotkey: '^X',  shortname: 'Create',     menuname: 'Create Task',description: '', function: :create_task},
			'clone_task' =>{ hotkey: '^D',  shortname: 'Clone',      menuname: 'Clone current Task',description: '', function: :clone_task, history: true},
			'select_task'=>{ hotkey: 'ENTER', hotkey_label: 'RET', shortname: 'Select',    menuname: 'Select Task', description: '', function: :select_task},
			'select_task_e'=>{ hotkey: 'E', hotkey_label: 'E', shortname: 'Select',    menuname: 'Select Task', description: '', function: :select_task},
			'prev_task'  => { hotkey: '^P',  shortname: 'To Prev',    menuname: 'To Previous',    description: 'Switch to previous task', function: :prev_task},
			'delete_task'=>{ hotkey: 'D',   shortname: 'Delete',    menuname: 'Delete Task', description: '', function: :delete_task, history: true},
			'undelete_task'=>{ hotkey: 'U',   shortname: 'Undelete',  menuname: 'Undelete Task', description: '', function: :undelete_task, history: true},
			'save_task' => { hotkey: '^X',  shortname: 'Save',        menuname: 'Save Changes',description: '', function: :create_task},
			# Write task does not exit task view after saving it
			'write_task' => { hotkey: '^W',  shortname: 'Write',        menuname: 'Write Changes',description: '', function: :create_task, function_arg: { window_change: false}},
			'set_priority'=>{ hotkey: [*(0..9).map{|x|x.to_s}], hotkey_label: '1-9', shortname: 'SetPriority',    menuname: 'Set Priority', description: '', function: :set_priority},
			'set_status'=>{ hotkey: [ 'T'], shortname: 'SetStatus',    menuname: 'Set Status', description: '', function: :set_status},

			'add_folder'=>{ hotkey: 'A',  shortname: 'Add',     menuname: 'Add Folder',description: '', function: :add_folder, history: true},
			'delete_folder'=>{ hotkey: 'D',  shortname: 'Delete',     menuname: 'Delete Folder',description: '', function: :delete_folder, history: true},

			'quit'      => { hotkey: 'Q',   shortname: 'Quit',        menuname: 'Quit',        description: 'Leave the Taskman program', function: :quit },
			# Handler for Quit Now can be nil because this is checked for and executed directly in the main loop. This entry exists only for showing in menu when you want.
			'quit_now'  => { hotkey: $opts['exit-key'], shortname: 'QuitNow',        menuname: 'Quit Now',        description: 'Quit Taskman Now', function: nil },
			'cancel_question'=> { hotkey: 'ESC', shortname: 'Cancel',        menuname: 'Cancel Question',        description: 'Cancel question', function: :cancel_question },

			# Actions related to status messages when a person tries to move beyond widget/page/window limits
			'top_list'=>   { hotkey: 'UP',  shortname: '',    menuname: '', description: '', function: :top_list},
			'bottom_list'=>{ hotkey: 'DOWN',shortname: '',    menuname: '', description: '', function: :bottom_list},
			'top_header'=> { hotkey: 'UP',  shortname: '',    menuname: '', description: '', function: :top_header},
			#'bottom_page'=>{ hotkey: 'DOWN',shortname: '',    menuname: '', description: ''},
			'top_help'=>   { hotkey: 'UP',  shortname: '',    menuname: '', description: '', function: :top_help},
			'bottom_help'=>{ hotkey: 'DOWN',shortname: '',    menuname: '', description: '', function: :bottom_help},

			# Actions for manual, MVC-based handling of lists
			'pos_up'=>     { hotkey: 'UP',  shortname: '',  menuname: '', description: '', function: :pos_up},
			'pos_down'=>   { hotkey: 'DOWN',shortname: '',  menuname: '', description: '', function: :pos_down},
			'pos_pgup'=>   { hotkey: 'PPAGE',shortname: 'PrevPage', menuname: '', description: '', function: :pos_pgup},
			'pos_pgdown'=> { hotkey: 'NPAGE',shortname: 'NextPage', menuname: '', description: '', function: :pos_pgdown},
			'pos_home'=>   { hotkey: 'HOME', hotkey_label: 'HOME', shortname: 'FirstPage',  menuname: '', description: '', function: :pos_home},
			'pos_end'=>    { hotkey: 'END', hotkey_label: 'END',  shortname: 'LastPage',  menuname: '', description: '', function: :pos_end},
			'pos_lastpos'=>{ hotkey: "'",  hotkey_label: 'GotoLast', shortname: 'GotoLast',  menuname: '', description: '', function: :pos_lastpos},

			# For moving within an array and printing current entry text into a box
			'array_up'=>     { hotkey: 'UP',  shortname: '',  menuname: '', description: '', function: :array_up},
			'array_down'=>   { hotkey: 'DOWN',shortname: '',  menuname: '', description: '', function: :array_down},

			# Misc
			'toggle_timing_options'=> { description: 'Toggle Timing Options', function: :toggle_timing_options},
			'toggle_reminding_options'=> { description: 'Toggle Remind Options', function: :toggle_reminding_options},
			'toggle'=> { hotkey: [ 'ENTER', 'SPACE'], hotkey_label: 'RET', description: 'Toggle', function: :toggle},
			'redraw'=>     { hotkey: '^L',  shortname: 'RedrawScr',menuname: 'Redraw Screen', description: '', function: :redraw},

			# For custom implementation of TableList
			'select_row'=>{ hotkey: '', hotkey_label: '', shortname: 'Select',    menuname: 'Select Row', description: '', function: :select_row},

			# OLD / Unused / Unfinished / Untested
			'other'     => { hotkey: 'O',   shortname: 'OTHER CMDS',  menuname: 'OTHER CMDS',  description: '', function: :menu_next_page },
			'other2'    => { hotkey: nil, hotkey_label:'O',  shortname: 'OTHER CMDS',  menuname: 'OTHER CMDS',  description: '', function: nil },
			'relnotes'  => { hotkey: 'R',   shortname: 'RelNotes',    menuname: 'RelNotes',    description: '', function: nil },
			'hotkey_out'=> { hotkey: [ '<', 'BACKSPACE' ],   shortname: 'Go Back',            menuname: 'Back',            description: 'Go Back to Previous Window', function: :prev_window, block: proc{ |arg| } },
			'kblock'    => { hotkey: 'K',   shortname: 'KBLock',      menuname: 'KBLock',      description: '', function: nil },
			'setup'     => { hotkey: 'S',   shortname: 'Setup',       menuname: 'Setup',       description: '', function: nil },
			'role'      => { hotkey: '#',   shortname: 'Role',        menuname: 'Role',        description: '', function: nil },
			'gotofolder'=> { hotkey: 'G',   shortname: 'GotoFldr',    menuname: 'GotoFldr',    description: '', function: nil },
			'journal'   => { hotkey: 'J',   shortname: 'Journal',     menuname: 'Journal',     description: '', function: nil },
			'addrbook'  => { hotkey: 'A',   shortname: 'AddrBook',    menuname: 'AddrBook',    description: '', function: nil },

			'whereis'   => { hotkey: 'W',   shortname: 'WhereIs',     menuname: 'Find String', description: 'Find a string', function: :whereis },
			'whereis_reverse'   => { hotkey: '?',   shortname: 'WhereIs',     menuname: 'Find String', description: 'Find a string', function: :whereis, function_arg: { direction: :prev} },
			'whereis_next'   => { hotkey: 'N',   shortname: 'Find Next',     menuname: 'Find Next', description: 'Find next occurrence', function: :whereis, function_arg: { interactive: false} },
			'whereis_prev'   => { hotkey: 'P',   shortname: 'Find Prev',     menuname: 'Find Previous', description: 'Find previous occurrence', function: :whereis, function_arg: { interactive: false, direction: :prev} },

			'cut_line'  => { hotkey: '^K',   shortname: 'Cut Line',         description: 'Cut line', function: nil, history: true},
			'postpone'  => { hotkey: '^O',   shortname: 'Postpone',         description: '', function: :postpone},
			'cancel'    => { hotkey: 'TIMEOUT', hotkey_label: '^C',  shortname: 'Cancel',           description: '', function: :cancel},
			'listfolders'=>{ hotkey: 'L',   shortname: 'FldrList',   menuname: 'FOLDER LIST', description: 'Select a folder to view', function: :list },

			'goto_line'=> { hotkey: [ 'J', ':' ],   shortname: 'Jump',    menuname: 'Jump to Line #',    description: '', function: :goto_line },

			'show_next_key'=> { hotkey: '^V',   shortname: 'ShowNextKey',        menuname: 'Show Next Key',        description: 'Show keycode of next key pressed', function: :show_next_key },

			'insert_datetime'=> { hotkey: $opts['datetime-key'],   shortname: 'Insert DateTime',        menuname: 'Insert Date/Time',        description: 'Insert current date and time', function: :insert_datetime, history: true },

			'repeat_last_action'  => { hotkey: '.',   shortname: 'RepeatLast',    menuname: 'Repeat Last Action',    description: 'Repeat Last Action', function: :repeat_last_action },

			'sortby'  => { hotkey: [ 'S', '$'],   shortname: 'SortBy',    menuname: 'Sort By Column',    description: 'Sort By Column', function: :sortby },
			'show_group'=> { hotkey: 'G',   shortname: 'ShowGroup',    menuname: 'Show Tasks in Group',    description: 'Show Tasks in Group', function: :show_group },

			# Testing shortcuts
			#'inc_folder_count'=> { hotkey: 'SR',   shortname: 'Folder Cnt+1',     description: '', function: :inc_folder_count },
			#'all_widgets_hash'=> { hotkey: 'SF',   shortname: 'All Children',     description: '', function: :all_widgets},
			#'parent_names'    => { hotkey: '^P',   shortname: 'Parent Tree',      description: '', function: :parent_names},
		}

		attr_accessor :name, :hotkey_label, :shortname, :menuname, :description, :function, :instant, :data, :default, :history, :block
		attr_reader :hotkey, :hotkeys

		def initialize arg= {}
			name= arg[:name]= arg[:name].to_s
			if name.length> 0
				@name= name
			end

			self.hotkeys= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[name] ? @@Menus[name][:hotkey] : nil
			@hotkey_label= arg.has_key?( :hotkey_label) ? arg.delete( :hotkey_label): @@Menus[name] ? ( @@Menus[name][:hotkey_label]|| @hotkey) : nil

			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[name] ? @@Menus[name][:shortname] : nil
			@menuname= arg.has_key?( :menuname) ? arg.delete( :menuname): @@Menus[name] ? @@Menus[name][:menuname] : nil
			@description= arg.has_key?( :description) ? arg.delete( :description).truncate2: @@Menus[name] ? @@Menus[name][:description].truncate2 : nil

			# Whether keypress instantly runs action, or only ENTER
			@instant= arg.has_key?( :instant) ? arg.delete( :instant): @@Menus[name] ? @@Menus[name][:instant] : nil
			# Whether this action is considered when searching for "default" action to execute (By default, yes, unless default== false)
			@default= arg.has_key?( :default) ? arg.delete( :default): @@Menus[name] ? @@Menus[name][:default] : nil

			# Function to execute
			@function= arg.has_key?( :function) ? arg.delete( :function) : @@Menus[name] ? @@Menus[name][:function] : nil
			@function_arg= arg.has_key?( :function_arg) ? arg.delete( :function_arg) : @@Menus[name][:function_arg] ? @@Menus[name][:function_arg] : {}

			@history= arg.has_key?( :history) ? arg.delete( :history) : @@Menus[name] ? @@Menus[name][:history] : true

			@block= arg.has_key?( :block) ? arg.delete( :block) : @@Menus[name] ? @@Menus[name][:block] : nil

			super

			# Allow provided blocks to store local state or shared state
			# between objects etc. in @data

			if block_given? then @data= yield arg.merge( self: self) end
			if @block then @block.call arg.merge( self: self) end



		end

		def hotkey= arg
			@hotkeys[0]= arg
			@hotkey= arg
		end
		def hotkeys= arg
			@hotkeys= arg.force_array
			@hotkey= @hotkeys[0]
		end

		# XXX Maybe do this the other way around with .merge, so that all
		# the values are filled in here, but if a person sends in any
		# arguments in arg, they override the ones here.
		def run arg= {}
			# Save this action for later calling again possibly, with '.'
			if @history
				$session.action_history<< @name
				$session.last_action= self
			end

			if Symbol=== f= @function
				self.send( f, arg.merge( action: self, function: f).merge( @function_arg))
			elsif Proc=== f= @function
				f.yield( arg.merge( action: self, function: f).merge( @function_arg))
			end
		end

		def menu_text
			# 2 - 5 - 15 - 4" - "2 - 33
			"%2s     %-15s    -  %-33s" % [ @hotkey.upcase, ( @menuname|| @shortname).upcase, @description]
		end

		################################### Functions ###################################

		def top_list arg= {}
			w= arg[:window]
			w.status_label_text= _('Already at top of list')
			nil
		end
		def bottom_list arg= {}
			w= arg[:window]
			w.status_label_text= _('Already at bottom of list')
			nil
		end
		def top_help arg= {}
			w= arg[:window]
			w.status_label_text= _('Already at start of help text')
			nil
		end
		def bottom_help arg= {}
			w= arg[:window]
			w.status_label_text= _('Already at end of help text')
			nil
		end
		def top_header arg= {}
			w= arg[:window]
			w.status_label_text= _(%q^Can't move beyond top of header^)
			nil
		end
		def bottom_page arg= {}
			w= arg[:window]
			w.status_label_text= _(%q^Can't move beyond bottom of page^)
			nil
		end

		# XXX See how these pre/post actions can be done automatically
		# somehow
		def quit arg= {}
			nr= $session.flags.select{ |k, v| v== 'D'}.count
			fmt= 'Really quit Taskman'
			args= []
			if nr> 0
				fmt+= ' and delete %d %s'
				args.push nr, nr.unit( _('task'))
			end
			fmt+= '?'
			$app.screen.ask( ( _( fmt)% args).truncate2, MenuAction.new(
				instant: true,
				# No need to specify ENTER among hotkeys because ENTER always
				# runs first action associated with widget.
				hotkey: [ _('Y'), _('N')],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				e= arg[:event]

				a= e.to_bool #wi.var_text_now.to_bool|| e.to_bool

				if a!= nil
					if a
						$session.flags.select{ |k, v|
							ki= k.to_i
							if v== 'D'
								if i= begin $session.sth.unscoped.find( ki) end
									i.destroy
									$session.flags.delete k
								end
							end
						}

						if $opts['state-save'] then $session.save end
						Stfl.reset
						puts _('Taskman finished.')
						exit 0
					else
						w['status_display'].var__display= 1
						w['status_prompt'].var__display= 0
						w.set_focus_default
					end
				end
				nil
			}))
			nil
		end
		def cancel arg= {}
			$app.screen.ask( _('Cancel task?'), MenuAction.new(
				instant: true,
				hotkey: [ _('Y'), _('N')],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				e= arg[:event]
				id= w['id'].var_text_now.to_i
				# We're using char_to_bool here as an ugly fix to require
				# that keypress be a single char. Otherwise, when a person
				# presses Ctrl+C to cancel, the event is "TIMEOUT" (due to
				# STFL workings) and .to_bool returns true, canceling
				# immediately.
				a= e.char_to_bool #wi.var_text_now.to_bool|| e.to_bool

				if a!= nil
					if a
						prev_window( arg.merge( pos_name: id))
					else
						w['status_display'].var__display= 1
						w['status_prompt'].var__display= 0
						w.set_focus_default
					end
				end
				nil
			}))
			nil
		end
		def cancel_question arg= {}
			w= arg[:window]
			w['status_display'].var__display= 1
			w['status_prompt'].var__display= 0
			w.set_focus_default
			nil
		end

		def add_folder arg= {}
			fmt= 'Folder name to add:'
			args= []
			$app.screen.ask( ( _( fmt)% args).truncate2, MenuAction.new(
				instant: false,
				function: Proc.new { |arg|
				## window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				#e= arg[:event]

				t= wi.var_text_now.strip
				if t.length> 0 and t=~ /\S/
					to= Folder.find_or_create_by( name: t)
					list( pos_name: to.id)
				end

				w['status_display'].var__display= 1
				w['status_prompt'].var__display= 0
				w.set_focus_default
				nil
			}))
			nil
		end
		def delete_folder arg= {}
			fmt= 'DELETE "%s"?'
			cat= Folder.find( arg[:widget].name.to_i)
			args= [ cat.name]
			bw= arg[:base_widget]
			$app.screen.ask( ( _( fmt)% args).truncate2, MenuAction.new(
				instant: true,
				# No need to specify ENTER among hotkeys because ENTER always
				# runs first action associated with widget.
				hotkey: [ _('Y'), _('N')],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				e= arg[:event]

				a= e.to_bool #wi.var_text_now.to_bool|| e.to_bool

				if a!= nil
					if a
						cat.destroy
						list( pos: bw.var_pos_now)
					else
						w['status_display'].var__display= 1
						w['status_prompt'].var__display= 0
						w.set_focus_default
					end
				end
				nil
			}))
			nil
		end

		def whereis arg= {}
			fmt= 'Word to search for [%s]:'
			swl1= $session.whereis.last
			args= [ swl1]
			bw= arg[:base_widget]

			# This is done in this way so that both UP and DOWN (moving up
			# and down the history list) would be moving along the same data
			# structure ($session.whereis) and be aware of the current
			# position (pos).
			data= { array: $session.whereis, pos: nil}
			up= MenuAction.new( name: 'array_up') { data}
			down= MenuAction.new( name: 'array_down') { data}

			a= MenuAction.new(
				instant: false,
				function_arg: { direction: arg[:direction]},
				function: Proc.new { |arg|
				## window, widget, action, function, event-- WWAFE
				w= arg[:window]
				t= ''

				# Important to have !arg[...]s here, otherwise arg[:widget]
				# refers to the current ListItem instead of the text typed into
				# the interactive whereis prompt
				if arg[:interactive]!= false and wi= arg[:widget]
					#e= arg[:event]
					t= wi.var_text_now #.strip
				end

				swl2= $session.whereis.last
				if !t or( t.length== 0 and swl2)
					t= swl2
				end

				pos= 0
				setter= 'var_pos='
				items= bw.widgets
				if List=== bw
					pos= bw.var_pos_now
				elsif Textview=== bw or Textedit=== bw
					pos= bw.var_offset_now
					setter= 'var_offset='
				end

				wrap_around= false
				found= false
				if t.length> 0
					# Remove any ocurrences of this string already existing in
					# search history, and add the string at the end (most recent)
					$session.whereis>> t
					$session.whereis<< t

					r= Regexp.new t, Regexp::IGNORECASE
					posids= nil
					if arg[:direction]== :prev
						# Find-Prev searches in the backward direction
						posids= [ *( 0..pos-1).to_a.reverse, *( ( pos)..( items.size- 1)).to_a.reverse]
					else
						# WhereIs or Find-Next search in the forward direction
						posids= [ *( ( pos+1)..( items.size- 1)), *( 0..pos)]
					end
					prev_i= posids[0]

					# Handles case when a person starts searching while on the first or
					# last item in the list
					if prev_i< pos and arg[:direction]!= :prev then wrap_around= true end
					if prev_i> pos and arg[:direction]== :prev then wrap_around= true end

					posids.each do |i|
						if prev_i> i and arg[:direction]!= :prev then wrap_around= true end
						if prev_i< i and arg[:direction]== :prev then wrap_around= true end
						prev_i= i
						if items[i].var_text_now=~ r
							found= true
							bw.send setter, i
							break
						end
					end
				end

				w['status_display'].var__display= 1
				w['status_prompt'].var__display= 0
				if found and wrap_around and arg[:direction]== :prev
					w.status_label_text= _('Search hit TOP, continuing at BOTTOM')
				elsif found and wrap_around
					w.status_label_text= _('Search hit BOTTOM, continuing at TOP')
				elsif !found
					w.status_label_text= _('Pattern not found: %s')% t
				end
				w.set_focus_default
				nil
			})
			
			if arg[:interactive]== false
				a.run arg
			else
				$app.screen.ask( ( _( fmt)% args).truncate2, a, up, down)
			end
			nil
		end

		def goto_line arg= {}
			fmt= ':'
			args= []
			bw= arg[:base_widget]
			$app.screen.ask( ( _( fmt)% args).truncate2, MenuAction.new(
				instant: false,
				function: Proc.new { |arg|
				## window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				#e= arg[:event]

				t= wi.var_text_now
				case t
					when /h/i
						bw.var_pos= bw.var_offset_now
					when /m/i
						bw.var_pos= bw.var_offset_now+ ( bw.var_offset_now+ bw._h_now/ 2).to_i
					when /l/i
						bw.var_pos= bw.var_offset_now+ bw._h_now- 1
					when /g/
						bw.var_pos= 0
					when /G/
						bw.var_pos= bw.widgets.size- 1
					else
						t= t.to_i- 1 #.strip
						t= 0 if t< 0
						if t.to_s.length>= 0 and t>= 0 and t.to_s=~ /^\d+$/
							bw.var_pos= t
						end
				end

				w['status_display'].var__display= 1
				w['status_prompt'].var__display= 0
				w.set_focus_default
				nil
			}))
			nil
		end

		# Hide the current menu and show the menu after it
		def menu_next_page arg= {}
			# Extract which window it was
			w= arg[:window]

			# See which menus we have. Exit if there are no
			# menus to cycle between.
			menus= w.menus
			return if menus.size< 2

			# Find the currently shown menu, hide it, and show the next
			# menu after it.
			show_next= nil
			w.menus.each do |m|
				if show_next
					m.var__display= 1
					return
				elsif m.var__display> 0
					m.var__display= 0
					show_next= true
				end
			end

			# If we are here, it means the menus have "wrapped" around,
			# (e.g. menu2 was shown, we hid it, and now we need to show menu1),
			# So we unconditionally shown the first menu in the array.
			menus[0].var__display= 1
			nil
		end

		def pos_home arg= {}
			w= arg[:window]
			wi= arg[:base_widget]
			if wi.var_pos_now== 0
				w.status_label_text= _('First Page')
				return nil
			end
			wi.var_pos= 0
			nil
		end
		def pos_end arg= {}
			w= arg[:window]
			wi= arg[:base_widget]
			epos= wi.widgets.size- 1
			if wi.var_pos_now== epos
				w.status_label_text= _('Last Page')
				return nil
			end
			wi.var_pos= epos
			nil
		end

		def pos_up arg= {}
			w= arg[:base_widget]
			wnd= arg[:window]

			# This is normal behavior, such as on key UP or on Page UP
			# when we're not near zero.
			step= arg[:step]|| 1
			step1= -1

			# See what our new pos would be
			p= w.var_pos_now- step

			# If new pos would be below position 0, then invert the logic
			# a bit-- instead of searching backwards, set position to 0
			# and focus on the first widget forward that is focusable.
			# Worst case, this will be the exact one on which the person
			# is currently located; effectively being a no-op.
			if p<= 0
				p= 0
				step1= 1
			end

			while p>= 0 and p< w.widgets.size
				wi= w.widgets[p]
				# We assume there is no need to test for var__display because
				# if the widget was hidden, it wouldn't receive an event. Also,
				# if we were to honor that correctly, we would have to look up
				# visibility of all widgets up to the top of the tree.
				# Not checking for this does allow for setting pos on a hidden
				# ListItem in a List though, user beware.
				if w.var_pos_now== p
					break
				end
				if wi.var_can_focus> 0 #and wi.var__display> 0
					w.var_pos= p
					return nil
				end
				p+= step1
			end

			wnd.status_label_text= _('Already at start')
			nil
		end
		def pos_pgup arg= {}
			w= arg[:base_widget]
			h= w._h_now # Height of widget
			a= arg.merge( step: h)
			pos_up a
			nil
		end

		def pos_down arg= {}
			w= arg[:base_widget]
			wnd= arg[:window]

			# This is normal behavior, such as on key UP or on Page UP
			# when we're not near zero.
			step= arg[:step]|| 1
			step1= -1

			p= w.var_pos_now+ step

			# Same logic as above in pos_up; just in the other direction
			max= w.widgets.count- 1
			if p> max
				p= max
				step1= -1
			end

			while p<= max
				wi= w.widgets[p]
				if w.var_pos_now== p
					break
				end
				if wi.var_can_focus> 0 #and wi.var__display> 0
					w.var_pos= p
					return
				end
				p+= step1
			end

			wnd.status_label_text= _('Already at end')
			nil
		end
		def pos_pgdown arg= {}
			w= arg[:base_widget]
			h= w._h_now # Height of widget
			a= arg.merge( step: h)
			pos_down a
			nil
		end

		def show_next_key arg= {}
			#w= arg[:window]
			#e= arg[:event]
			$session.show_next_key= true
			nil
		end

		def pos_lastpos arg= {}
			w= arg[:window]
			wi= arg[:base_widget]
			if wi.last_pos
				wi.var_pos= wi.last_pos
			end
			nil
		end

		############################### Testing Functions ################################

#		def inc_folder_count arg= {}
#			$app.screen['folder_count'].var_text+= 1
#			#pfl $app.screen['folder_count'].parent_tree.map { |x| x.name }
#		end
#		# This cannot be named "all_widgets_hash" or endless loop will ensue :)
#		# (Due to the widget above being called "all_widgets_hash" as well)
#		def all_widgets arg= {}
#			pfl $app.screen.all_widgets_hash.keys
#		end
#
#		def get_create_help arg= {}
#		end
#
		def main arg= {}
			$app.exec( arg.merge( window: 'main'))
			nil
		end
		def create arg= {}
			$app.exec( arg.merge( window: 'create'))
			nil
		end
		def index arg= {}
			$app.exec( arg.merge( window: 'index'))
			nil
		end
		def list arg= {}
			$app.exec( arg.merge( window: 'list'))
			nil
		end
		def help arg= {}
			$app.exec( arg.merge( window: 'help'))
			nil
		end

		def clone_task arg= {}
			w= arg[:window]
			id= w['id'].var_text_now.to_i
			#db= w['db'].var_text_now.to_sym
			return unless id #and db

			t= $session.dbh.find id #$tasklist.by_aid [db, id]
			t2= t.dup
			t2.folders= t.folders
			t2.save

			if w.respond_to? :status_label_text=
				w.status_label_text= _('Task cloned')
				$app.ui.run -1
				sleep $opts['echo-time']
			else
				pfl e
			end

			index arg.merge( pos_name: t2.id)
			nil
		end

		def create_task arg= {}
			w= arg[:window]

			id= w['id'].var_text_now.to_i
			db= :main #w['db'].var_text_now.to_sym

			created= false

			#i= begin
			#	arg[:item]|| db.to_item_class.find( id)
			#rescue
			#	db.to_item_class.new
			#	created= true
			#end
			i= arg[:item]|| begin
				Item.find( id)
			rescue
				created= true
				Item.new # $session.dbn.to_item_class.new
			end

			if id> 0 then i.id= id end

			begin

				# These are single-value, non-null keys
				[
					:subject,
					:start,
					:stop,
					:time_ssm,
					:omit_shift,
					:omit_remind,
					:message,
				].each do |f|
					v= w[f.to_s].var_text_now.strip
					next unless v.length> 0
					# Save person's original input for eventual
					# editing/modification later
					i.send "_#{f}=", v
					i.send "parse_#{f}", v
				end

				## These are single-value, null keys
				#[
				#	:status,
				#].each do |f|
				#	v= w[f.to_s].var_text_now.strip
				#	#next unless v.length> 0
				#	# Save person's original input for eventual
				#	# editing/modification later
				#	i.send "_#{f}=", v
				#	i.send "parse_#{f}", v
				#end

				# These are multi-value keys
				[
					:due,
					:omit,
					:remind,
				].each do |f|
					list= w[f.to_s].var_text_now.split /,/
					list.each do |v|
						v.strip!
						next unless v.length> 0
						# Save person's original input for eventual
						# editing/modification later
						i.send "_#{f}=", v
						i.send "parse_#{f}", v
					end
				end

				# Extract categories
				awh= $app.screen.all_widgets_hash
				cats= awh.keys.select{ |f| f.match '^foldername_'}
				fnames= []
				cats.each do |c| fnames.push c[11..-1] if awh[c].var_value_now== 1 end
				fnames= fnames.join ' '
				i.send "_folder_names=", fnames
				i.send "parse_folder_names", fnames

				# Extract status
				#awh= $app.screen.all_widgets_hash
				ws= awh.keys.select{ |f| f.match '^statusname_'}
				ss= []
				ws.each do |w|
					if awh[w].var_value_now== 1
						ss.push w[11..-1]
					end
				end
				# (Even though we know there will always only be one)
				ss= ss.join ' '
				i.send "_status=", ss
				i.send "parse_status", ss

				i.save

				$app.screen['id'].var_text= i.id

				if w.respond_to? :status_label_text=
					w.status_label_text= if created then _('Task created') else _('Task saved') end
					$app.ui.run -1
					sleep $opts['echo-time'] if arg[:window_change]!= false
				else
					pfl e
				end

				if arg[:window_change]!= false
					index arg.merge( pos_name: i.id)
				end

			# XXX We replace/complement this with StandardError?
			rescue Exception => e
				w= arg[:window]
				if w.respond_to? :status_label_text=
					w.status_label_text= e.to_s
				else
					pfl e
				end
			end
			nil
		end

		def select_task arg= {}
			id= if arg[:function_arg] then arg[:function_arg] else $app.ui.get( 'list_pos_name') end

			$session.task_history<< id

			arg2= {
				window: 'create',
				title: 'VIEW / EDIT TASK',
				open_timing: true,
				open_reminding: true,
				id: id.to_i
			}
			create arg2
			nil
		end
		def prev_task arg= {}
			pt= $session.task_history[-2]
			if pt
				select_task arg.merge( function_arg: pt.to_i)
			end
			nil
		end
		def delete_task arg= {}
			w= arg[:widget]
			id= w.name.to_i
			#db= id[0].to_item_class
			#id= id[1]
			t= $session.dbh.find( id) #db.find( id)
			t.flag= 'D'
			index( {
				pos: arg[:base_widget].var_pos_now+ 1,
				status_label_text: _("Task %s marked for deletion")% w.name
			})
			nil
		end
		def undelete_task arg= {}
			w= arg[:widget]
			id= w.name.to_i
			#db= id[0].to_item_class
			#id= id[1]
			t= $session.dbh.find( id) #db.find( id)
			t.flag= nil
			index( {
				pos: arg[:base_widget].var_pos_now,
				status_label_text: _(%q^Deletion mark removed, task won't be deleted^)
			})
			nil
		end

		def toggle arg= {}
			w= arg[:widget]
			w.toggle
			nil
		end

		def toggle_timing_options arg= {}
			w= arg[:window]
			wh= w['timing']
			wh.toggle
			v= wh.var_value
			w['timing_options'].var__display= v
			nil
		end

		def toggle_reminding_options arg= {}
			w= arg[:window]
			wh= w['reminding']
			wh.toggle
			v= wh.var_value
			w['reminding_options'].var__display= v
			nil
		end

		def nextcmd2 arg= {}
			w= arg[:widget]
			wp= w.parent
			if wp.var_pos<= 7
				wp.var_pos+= 2
				$app.screen.main_loop -1
			else
				$app.screen.status_label_text= _('Already at bottom of list')
			end
			nil
		end
		def prevcmd2 arg= {}
			w= arg[:widget]
			wp= w.parent
			if wp.var_pos>= 2
				wp.var_pos-= 2
				$app.screen.main_loop -1
			else
				$app.screen.status_label_text= _('Already at top of list')
			end
			nil
		end

		# These two need no implementation because they are currently used in
		# textviews only, and those widgets handle HOME/END for first/last
		# page on their own.
		# But, if the implementation will be needed (for e.g. use in some other
		# widgets, or for textviews with auto key bindings disabled), then
		# implement here something similar to nextpage/prevpage below.
		def firstpage arg= {}
			nil
		end
		def lastpage arg= {}
			nil
		end

		# XXX move those into separate functions
		def nextpage arg= {}
			w= arg[:widget]
			c= w.var_text_now.lines.count # Lines count
			h= w._h_now # Height of widget
			o= w.var_offset_now.to_i # Current offset
			mo= c- h+ 1 # Max valid offset
			no= o+ h # Would-be new offset
			no2= if no> mo then mo else no end # Valid new offset
			w.var_offset= no2
			nil
		end
		def prevpage arg= {}
			w= arg[:widget]
			h= w._h_now # Height of widget
			o= w.var_offset_now.to_i # Current offset
			mo= 0 # Min valid offset
			no= o- h # Would-be new offset
			no2= if no< mo then mo else no end # Valid new offset
			w.var_offset= no2
			nil
		end

		def redraw arg= {}
			Stfl.redraw
			nil
		end

		def select_row arg= {}
			w= arg[:widget]
			wi= arg[:window]
			bw= arg[:base_widget]
			#a= arg[:action]
			#f= arg[:function]
			e= arg[:event]

			# Mark this row as selected
			row= bw.prev_row
			if row
				row.widgets.each do |rw|
					rw.apply_style # Will apply normal style
				end
			end
			row= w.parent
			row.widgets.each do |rw|
				rw.apply_style( normal: :focus)
			end
			bw.prev_row= row

			nil
		end

		def array_up arg= {}
			# Here, we do not say size- 1 because we -1 in the
			# line before it.
			a= arg[:action]
			pos= a.data[:pos]|| a.data[:array].size
			pos-= 1 if pos> 0
			a.data[:pos]= pos
			arg[:widget].var_text= a.data[:array][pos]
		end
		def array_down arg= {}
			# Here, we do not say size- 1 because we want the
			# .size() index (which is nonexistent) to result in
			# user being able to return to empty line.
			max= @data[:array].size
			pos= @data[:pos]|| max
			pos+=1 if pos< max
			@data[:pos]= pos
			arg[:widget].var_text= $session.whereis[pos]
		end


		def insert_datetime arg= {}
			w= arg[:widget]
			#pfl w.name

			t= w.var_text_now
			timestr= Time.now.strftime( $opts['datetime-format'])
			pos= w.var_pos_now+ w.var_scroll_x_now+ w.var_cursor_x_now

			# This works for inputs only, not textedits?
			pre= t[0...pos]|| ''
			post= t[pos..-1]|| ''
			t= pre+ timestr+ post

			w.var_text= t
			w.var_pos= w.var_pos_now+ timestr.length
		end

		def save_session arg= {}
			$session.save
		end

		def prev_window arg= {}
			w= $session.window_history[-2]|| 'main'
			$app.exec( arg.merge( window: w))
			nil
		end

		def repeat_last_action arg= {}
			# See if this needs to be limited to actions of the same name, type or other criteria
			if a= $session.last_action
				a.run arg
			#else
			#	$app.screen.status_label_text= _('Action buffer empty')
			end
		end

		def set_priority arg= {}
			id= if arg[:function_arg] then arg[:function_arg] else $app.ui.get( 'list_pos_name') end
			id= id.to_i

			prio= arg[:event].to_i* $opts['priority-granularity']
			sfid = if $session.folder then $session.folder.id else nil end

			pos= arg[:base_widget].var_pos_now
			pos_name= arg[:base_widget].var_pos_name_now

			begin
				i= Item.unscoped.find id
				p= i.categorizations.create_with( priority: prio).find_or_create_by( folder_id: sfid, item_id: id)
				p.priority= prio
				p.save

				if $opts['follow-jump']
					index arg.merge( pos_name: pos_name)
				else
					index arg.merge( pos: pos)
				end
			rescue Exception => e
				p "Task ID #{id}: #{e}"
			end

			nil
		end

		def set_status arg= {}
			id= if arg[:function_arg] then arg[:function_arg] else $app.ui.get( 'list_pos_name') end
			id= id.to_i

			statuses= Status.all
			fmt= _( 'Set Status: ')
			map= { }
			fmts= [ ]
			i= 1
			statuses.each do |s|
				map[i.to_s]= s.name
				fmts.push '[%d] %s' % [ i, s.name]
				i+= 1
			end
			fmt+= fmts.join( '  ')+ '  [Any] '+ _('Cancel')
			pos= arg[:base_widget].var_pos_now
			pos_name= arg[:base_widget].var_pos_name_now

			$app.screen.ask( ( _( fmt)).truncate2, MenuAction.new(
				instant: true,
				hotkey: [ *map.keys, 'ENTER'],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				#wi= arg[:widget]
				e= arg[:event]

				a= e
				handled= false

				if map.has_key? a
					handled= true
					val= map[a]

					begin
						s= Status.unscoped.find a.to_i
						i= Item.unscoped.find id
						i.status_id= s.id
						i.save

						if $opts['follow-jump']
							index arg.merge( pos_name: pos_name)
						else
							index arg.merge( pos: pos)
						end
					rescue Exception => e
						p "Task ID #{id}: #{e}"
					end
				end

				if handled
					if $opts['follow-jump']
						index arg.merge( pos_name: pos_name)
					else
						index arg.merge( pos: pos)
					end
				else
					w['status_display'].var__display= 1
					w['status_prompt'].var__display= 0
					w.set_focus_default
				end
				nil
			}))
			nil
		end

		def sortby arg= {}
			fmt= _( 'Sort By: [1,!] %s, [2,@] %s, [3,#] %s, [4,$] %s, [Any] %s')
			args= [ _('ID'),  _('Status'),  _('Subject'),  _('Priority'), _('Cancel')]
			pos= arg[:base_widget].var_pos_now
			pos_name= arg[:base_widget].var_pos_name_now
			$app.screen.ask( ( _( fmt)% args).truncate2, MenuAction.new(
				instant: true,
				# No need to specify ENTER among hotkeys because ENTER always
				# runs first action associated with widget.
				hotkey: [ '1', '2', '3', '4', 'ENTER'],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				e= arg[:event]

				a= e
				handled= false

				if a== '1'
					$session.order= [ '-items.id DESC']
					handled= true
				elsif a== '!'
					$session.order= [ '-items.id ASC']
					handled= true
				elsif a== '2'
					$session.order= [ 'status_id ASC']
					handled= true
				elsif a== '@' or a== '"'
					$session.order= [ 'status_id DESC']
					handled= true
				elsif a== '3'
					$session.order= [ 'subject ASC']
					handled= true
				elsif a== '#'
					$session.order= [ 'subject DESC']
					handled= true
				elsif a== '4'
					$session.order= [ '-categorizations.priority DESC']
					handled= true
				elsif a== '$'
					$session.order= [ '-categorizations.priority ASC']
					handled= true
				end

				if handled
					if $opts['follow-jump']
						index arg.merge( pos_name: pos_name)
					else
						index arg.merge( pos: pos)
					end
				else
					w['status_display'].var__display= 1
					w['status_prompt'].var__display= 0
					w.set_focus_default
				end
				nil
			}))
			nil
		end

		def show_group arg= {}
			statuses= Status.select( :category).distinct
			fmt= _( 'Show Group: ')
			map= { '1' => 'All'}
			fmts= [ '[1] All']
			i= 2
			statuses.each do |s|
				map[i.to_s]= s.category
				fmts.push '[%d] %s' % [ i, s.category]
				i+= 1
			end
			fmt+= fmts.join( '  ')+ '  [Any] '+ _('Cancel')
			pos= arg[:base_widget].var_pos_now
			pos_name= arg[:base_widget].var_pos_name_now

			$app.screen.ask( ( _( fmt)).truncate2, MenuAction.new(
				instant: true,
				hotkey: [ *map.keys, 'ENTER'],
				function: Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				#wi= arg[:widget]
				e= arg[:event]

				a= e
				handled= false

				if map.has_key? a
					$session.status_group_name= map[a]
					handled= true
					if a== '1'
						$session.where= 1
					else
						val= map[a]
						if map[a]== 'OPEN'
							val= [ nil, val]
						end
						$session.where= { statuses: { category: val}}
					end
				end

				if handled
					if $opts['follow-jump']
						index arg.merge( pos_name: pos_name)
					else
						index arg.merge( pos: pos)
					end
				else
					w['status_display'].var__display= 1
					w['status_prompt'].var__display= 0
					w.set_focus_default
				end
				nil
			}))
			nil
		end

	end
end
