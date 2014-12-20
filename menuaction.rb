module TASKMAN

	class MenuAction < Widget

		attr_accessor :name, :hotkey, :hotkey_label, :shortname, :menuname, :description, :function
		
		# TODO move this to outside file
		@@Menus= {
			# To have multiple "same" menus, you must use different names
			'help'      => { :hotkey=> '?',   :shortname=> 'Help',        :menuname=> 'Help',        :description=> 'Get help using Taskman', :function=> :help},
			'help2'     => { :hotkey=> '?',   :shortname=> 'Help',        :menuname=> 'Help',        :description=> 'Get help using Taskman', :function=> :help},
			'get_help'  => { :hotkey=> '^G',  :shortname=> 'Get Help',    :menuname=> 'Get Help',    :description=> 'Get help',               :function=> :help},
			'exit_help' => { :hotkey=> 'E',   :shortname=> 'Exit Help',   :menuname=> 'Exit Help',   :description=> 'Exit Help', :function=> :main },

			# For the empty slot, no need to use a different name even if it appears multiple times, because empty name results in the name being auto-generated
			''          => { :hotkey=> '',    :shortname=> '',            :menuname=> '',            :description=> '', :function=> nil }, # Empty one

			# The current useful bulk of our actions
			'hotkey_in' => { :hotkey=> '>',   :shortname=> '',            :menuname=> '',            :description=> '', :function=> nil },

			'nextcmd2'  => { :hotkey=> 'N',   :shortname=> 'NextCmd',     :menuname=> 'NextCmd',     :description=> '', :function=> :nextcmd2 },
			'prevcmd2'  => { :hotkey=> 'P',   :shortname=> 'PrevCmd',     :menuname=> 'PrevCmd',     :description=> '', :function=> :prevcmd2 },
			'firstpage' => { :hotkey=> 'HOME',:shortname=> 'FirstPage',   :menuname=> 'FirstPage',   :description=> '', :function=> :firstpage },
			'lastpage'  => { :hotkey=> 'END', :shortname=> 'LastPage',    :menuname=> 'LastPage',    :description=> '', :function=> :lastpage },
			'nextpage'  => { :hotkey=> 'SPACE', :hotkey_label=> 'SPC', :shortname=> 'NextPage',   :menuname=> 'NextPage',    :description=> '', :function=> :nextpage },
			'prevpage'  => { :hotkey=> '-',   :shortname=> 'PrevPage',    :menuname=> 'PrevPage',    :description=> '', :function=> :prevpage },

			'main'      => { :hotkey=> '^M',  :shortname=> 'Main Menu',   :menuname=> 'Main Menu',   :description=> 'Main Menu', :function=> :main },
			'create'    => { :hotkey=> 'C',   :shortname=> 'Create',      :menuname=> 'Create Task', :description=> 'Create a task', :function=> :create },
			'index'     => { :hotkey=> 'I',   :shortname=> 'Index',       :menuname=> 'Task Index',  :description=> 'View tasks in current folder', :function=> :index },
			'to_index'  => { :hotkey=> '^T',  :shortname=> 'Index',       :menuname=> 'To Index',    :description=> 'View tasks in current folder', :function=> :index },

			'create_task'=> { :hotkey=> '^X',  :shortname=> 'Create',     :menuname=> 'Create a Task',:description=> '', :function=> :create_task},
			'clone_task' => { :hotkey=> '^D',  :shortname=> 'Clone',      :menuname=> 'Clone current Task',:description=> '', :function=> :clone_task},
			'select_task'=> { :hotkey=> 'ENTER', :hotkey_label=> 'RET', :shortname=> 'Select',    :menuname=> 'Select Task', :description=> '', :function=> :select_task},
			'save_task' => { :hotkey=> '^X',  :shortname=> 'Save',        :menuname=> 'Save Changes',:description=> '', :function=> :create_task},

			'quit'      => { :hotkey=> 'Q',   :shortname=> 'Quit',        :menuname=> 'Quit',        :description=> 'Leave the Taskman program', :function=> :quit },

			# Actions related to status messages when a person tries to move beyond widget/page/window limits
			'top_list'=>    { :hotkey=> 'UP',  :shortname=> '',    :menuname=> '', :description=> '', :function=> :top_list},
			'bottom_list'=> { :hotkey=> 'DOWN',:shortname=> '',    :menuname=> '', :description=> '', :function=> :bottom_list},
			'top_header'=>  { :hotkey=> 'UP',  :shortname=> '',    :menuname=> '', :description=> '', :function=> :top_header},
			#'bottom_page'=> { :hotkey=> 'DOWN',:shortname=> '',    :menuname=> '', :description=> ''},
			'top_help'=>    { :hotkey=> 'UP',  :shortname=> '',    :menuname=> '', :description=> '', :function=> :top_help},
			'bottom_help'=> { :hotkey=> 'DOWN',:shortname=> '',    :menuname=> '', :description=> '', :function=> :bottom_help},

			# Misc
			'toggle_timing_options'=> { :description=> 'Toggle Timing Options', :function=> :toggle_timing_options},
			'toggle_reminding_options'=> { :description=> 'Toggle Remind Options', :function=> :toggle_reminding_options},
			'redraw'=>      { :hotkey=> '^L',  :shortname=> 'RedrawScr',:menuname=> 'Redraw Screen', :description=> '', :function=> :redraw},

			# Testing shortcuts
			'inc_folder_count'  => { :hotkey=> 'SR',   :shortname=> 'Folder Cnt+1',     :description=> '', :function=> :inc_folder_count },
			'all_widgets_hash'  => { :hotkey=> 'SF',   :shortname=> 'All Children',     :description=> '', :function=> :all_widgets},
			'parent_names'      => { :hotkey=> '^P',   :shortname=> 'Parent Tree',      :description=> '', :function=> :parent_names},
			'read_self_text'    => { :hotkey=> '^P',:shortname=> 'Read self text',   :description=> '', :function=> :read_self_text},

			# OLD / Unused / Unfinished / Untested
			'other'     => { :hotkey=> 'O',   :shortname=> 'OTHER CMDS',  :menuname=> 'OTHER CMDS',  :description=> '', :function=> :menu_next_page },
			'other2'    => { :hotkey=> 'O',   :shortname=> 'OTHER CMDS',  :menuname=> 'OTHER CMDS',  :description=> '', :function=> :menu_next_page },
			'relnotes'  => { :hotkey=> 'R',   :shortname=> 'RelNotes',    :menuname=> 'RelNotes',    :description=> '', :function=> nil },
			'hotkey_out'=> { :hotkey=> '<',   :shortname=> '',            :menuname=> '',            :description=> '', :function=> nil },
			'kblock'    => { :hotkey=> 'K',   :shortname=> 'KBLock',      :menuname=> 'KBLock',      :description=> '', :function=> nil },
			'setup'     => { :hotkey=> 'S',   :shortname=> 'Setup',       :menuname=> 'Setup',       :description=> '', :function=> nil },
			'role'      => { :hotkey=> '#',   :shortname=> 'Role',        :menuname=> 'Role',        :description=> '', :function=> nil },
			'gotofolder'=> { :hotkey=> 'G',   :shortname=> 'GotoFldr',    :menuname=> 'GotoFldr',    :description=> '', :function=> nil },
			'journal'   => { :hotkey=> 'J',   :shortname=> 'Journal',     :menuname=> 'Journal',     :description=> '', :function=> nil },
			'addrbook'  => { :hotkey=> 'A',   :shortname=> 'AddrBook',    :menuname=> 'AddrBook',    :description=> '', :function=> nil },
			'whereis'   => { :hotkey=> 'W',   :shortname=> 'WhereIs',     :menuname=> 'Find String', :description=> 'Find a string', :function=> nil },
			'cut_line'  => { :hotkey=> '^K',   :shortname=> 'Cut Line',         :description=> 'Cut line', :function=> nil},
			'postpone'  => { :hotkey=> '^O',   :shortname=> 'Postpone',         :description=> '', :function=> :postpone},
			'cancel'    => { :hotkey=> 'TIMEOUT', :hotkey_label=> '^C',  :shortname=> 'Cancel',           :description=> '', :function=> :cancel},
			'listfolders'=> { :hotkey=> 'L',   :shortname=> 'ListFldrs',   :menuname=> 'FOLDER LIST', :description=> 'Select a folder to view', :function=> nil },
		}

		def initialize arg= {}
			name= arg[:name]= arg[:name].to_s
			if name.length> 0
				@name= name
			end
			@hotkey= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[name] ? @@Menus[name][:hotkey] : nil
			@hotkey_label= arg.has_key?( :hotkey_label) ? arg.delete( :hotkey_label): @@Menus[name] ? ( @@Menus[name][:hotkey_label]|| @@Menus[name][:hotkey]|| @hotkey) : nil
			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[name] ? @@Menus[name][:shortname] : nil
			@menuname= arg.has_key?( :menuname) ? arg.delete( :menuname): @@Menus[name] ? @@Menus[name][:menuname] : nil
			@description= arg.has_key?( :description) ? arg.delete( :description).truncate: @@Menus[name] ? @@Menus[name][:description].truncate : nil

			# Function to execute can be specified in a parameter or come from a default.
			# If none of that is specified, it defaults to a function named the same as
			# the menuaction itself.
			@function= arg.has_key?( :function) ? arg.delete( :function) : @@Menus[name] ? @@Menus[name][:function] : nil

			super
		end

		def menu_text
			# 2 - 5 - 15 - 4" - "2 - 33
			"%2s     %-15s    -  %-33s" % [ @hotkey.upcase, ( @menuname|| @shortname).upcase, @description]
		end

		################################### Functions ###################################

		def top_list arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= '[Already at top of list]'
			end
		end
		def bottom_list arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= '[Already at bottom of list]'
			end
		end
		def top_help arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= '[Already at start of help text]'
			end
		end
		def bottom_help arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= '[Already at end of help text]'
			end
		end
		def top_header arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= "[ Can't move beyond top of header ]"
			end
		end
		def bottom_page arg= {}
			w= arg[:window]
			if wh= w['status_label']
				wh.var_text= "[ Can't move beyond bottom of page ]"
			end
		end

		# XXX See how this pre/post actions can be done automatically
		# somehow
		def quit arg= {}
			$app.screen.ask( _('Really quit Taskman?'), Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				a= wi.var_text_now.to_bool
				if a
					Stfl.reset
					#puts "Taskman finished. (#{$cnt}, #{$ctm})"
					puts 'Taskman finished.'
					exit 0
				end
				w['status_display'].var__display= 1
				w['status_prompt'].var__display= 0
				w.focus_default
			})
		end
		def cancel arg= {}
			$app.screen.ask( _('Cancel task?'), Proc.new { |arg|
				# window, widget, action, function, event-- WWAFE
				w= arg[:window]
				wi= arg[:widget]
				a= wi.var_text_now.to_bool
				if a
					main arg
				end
				w['status_display'].var__display= 1
				w['status_prompt'].var__display= 0
				w.focus_default
			})
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
		end

		def read_self_text arg= {}
			w= arg[:window]
			wh= w['input']
			input= wh['input']
			output= wh['output']
			output.var_text= 'Value of input: '+ $app.ui.text( 'input') #input.var_text_now
		end

		############################### Testing Functions ################################

#		def inc_folder_count arg= {}
#			$app.screen['folder_count'].var_text+= 1
#			#pfl $app.screen['folder_count'].parent_tree.map { |x| x.name }
#		end
#		# This cannot be named "all_widgets_hash" or endless loop will ensue :)
#		# (Due to the widget above being called "all_widgets_hash" as well)
#		def all_widgets arg= {}
#			pfl $app.screenall_widgets_hash.keys
#		end
#
#		def get_create_help arg= {}
#		end
#
		def main arg= {}
			$app.exec( :window=> 'main')
		end
		def create arg= {}
			$app.exec( :window=> 'create')
		end
		def index arg= {}
			$app.exec( :window=> 'index')
		end
		def help arg= {}
			$app.exec( :window=> 'help')
		end

		def clone_task arg= {}
			id= $app.screen['id'].var_text_now.to_i
			return unless id

			t= $tasklist[:tasks][id]
			t2= t.clone
			t2.generate_id
			$tasklist[:tasks][t2.id]= t2
			$app.screen.status_label_text= 'Task cloned'
			$tasklist.save
		end

		def create_task arg= {}
			w= arg[:window]
			i= arg[:item]|| Item.new
			id= $app.screen['id'].var_text_now.to_i
			if id> 0 then i.id= id end

			begin

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

				$tasklist[:tasks][i.id]= i
				$tasklist.save

				$app.screen['id'].var_text= i.id

				if w.respond_to? :status_label_text=
					w.status_label_text= _('Task created')
				else
					pfl e
				end

				index arg

			rescue Exception => e
				w= arg[:window]
				if w.respond_to? :status_label_text=
					w.status_label_text= e.to_s
				else
					pfl e
				end
			end
		end

		def select_task arg= {}
			arg2= {
				:window=> 'create',
				:title=> 'VIEW / EDIT TASK',
				:open_timing=> 1,
				:open_reminding=> 1,
				:id=> $app.ui.get( 'list_pos_name').to_i
			}
			$app.exec arg2
		end

		def toggle_timing_options arg= {}
			w= arg[:window]
			wh= w['timing']
			wh.toggle
			v= wh.var_value
			w['timing_options'].var__display= v
		end

		def toggle_reminding_options arg= {}
			w= arg[:window]
			wh= w['reminding']
			wh.toggle
			v= wh.var_value
			w['reminding_options'].var__display= v
		end

		def nextcmd2 arg= {}
			w= arg[:widget]
			wp= w.parent
			wp.var_pos+= 2 if wp.var_pos<= 7
			$app.screen.main_loop -1
		end
		def prevcmd2 arg= {}
			w= arg[:widget]
			wp= w.parent
			wp.var_pos-= 2 if wp.var_pos>= 2
			$app.screen.main_loop -1
		end

		# These two need no implementation because they are currently used in
		# textviews only, and those widgets handle HOME/END for first/last
		# page on their own.
		# But, if the implementation will be needed (for e.g. use in some other
		# widgets, or for textviews with auto key bindings disabled), then
		# implement similar to nextpage/prevpage below.
		def firstpage arg= {}
		end
		def lastpage arg= {}
		end

		def nextpage arg= {}
			w= arg[:widget]
			c= w.var_text_now.lines.count # Lines count
			h= w._h_now # Height of widget
			o= w.var_offset_now.to_i # Current offset
			mo= c- h+ 1 # Max valid offset
			no= o+ h # Would-be new offset
			no2= if no> mo then mo else no end # Valid new offset
			w.var_offset= no2
		end
		def prevpage arg= {}
			w= arg[:widget]
			h= w._h_now # Height of widget
			o= w.var_offset_now.to_i # Current offset
			mo= 0 # Min valid offset
			no= o- h # Would-be new offset
			no2= if no< mo then mo else no end # Valid new offset
			w.var_offset= no2
		end

#		def postpone arg= {}
#		end
#
#
#		def parent_names arg= {}
#			w= arg[:widget]
#			pt= w.parent_tree
#			pfl pt.map{ |x| x.name}
#		end

		def redraw arg= {}
			Stfl.redraw
		end

	end

	def save_tasklist
		$tasklist.save
	end

end
