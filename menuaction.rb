module TASKMAN

	class MenuAction < Widget

		attr_accessor :name, :hotkey, :shortname, :menuname, :description, :function
		
		# TODO move this to outside file
		@@Menus= {
			# To have multiple "same" menus, you must use different names
			'help'       => { :hotkey => '?',   :shortname => 'Help',        :menuname => 'Help',        :description => 'Get help using Taskman', :function => Proc.new { puts "YEHUDA KATZ!" }},
			'help2'      => { :hotkey => '?',   :shortname => 'Help',        :menuname => 'Help',        :description => 'Get help using Taskman', :function => Proc.new { puts "YEHUDA KATZ!" }},

			# For the empty slot, no need to use a different name even if
			# it appears multiple times, because empty name results in the
			# name being auto-generated
			''           => { :hotkey => '',    :shortname => '',            :menuname => '',            :description => '', :function => nil }, # Empty one

			'prevcmd'    => { :hotkey => 'p',   :shortname => 'PrevCmd',     :menuname => 'PrevCmd',     :description => '', :function => nil },
			'relnodes'   => { :hotkey => 'r',   :shortname => 'RelNotes',    :menuname => 'RelNotes',    :description => '', :function => nil },

			'other'      => { :hotkey => 'o',   :shortname => 'OTHER CMDS',  :menuname => 'OTHER CMDS',  :description => '', :function => :menu_next_page },
			'other2'     => { :hotkey => 'o',   :shortname => 'OTHER CMDS',  :menuname => 'OTHER CMDS',  :description => '', :function => :menu_next_page },

			'hotkey_in'  => { :hotkey => '>',   :shortname => '',            :menuname => '',            :description => '', :function => nil },
			'hotkey_out' => { :hotkey => '<',   :shortname => '',            :menuname => '',            :description => '', :function => nil },
			'nextcmd'    => { :hotkey => 'n',   :shortname => 'NextCmd',     :menuname => 'NextCmd',     :description => '', :function => nil },
			'kblock'     => { :hotkey => 'k',   :shortname => 'KBLock',      :menuname => 'KBLock',      :description => '', :function => nil },
			'quit'       => { :hotkey => 'q',   :shortname => 'Quit',        :menuname => 'Quit',        :description => 'Leave the Taskman program', :function => :quit },
			'folder_list'=> { :hotkey => 'l',   :shortname => 'ListFldrs',   :menuname => 'FOLDER LIST', :description => 'Select a folder to view', :function => nil },
			'setup'      => { :hotkey => 's',   :shortname => 'Setup',       :menuname => 'Setup',       :description => '', :function => nil },
			'role'       => { :hotkey => '#',   :shortname => 'Role',        :menuname => 'Role',        :description => '', :function => nil },
			'gotofolder' => { :hotkey => 'g',   :shortname => 'GotoFldr',    :menuname => 'GotoFldr',    :description => '', :function => nil },
			'journal'    => { :hotkey => 'j',   :shortname => 'Journal',     :menuname => 'Journal',     :description => '', :function => nil },
			'addrbook'   => { :hotkey => 'a',   :shortname => 'AddrBook',    :menuname => 'AddrBook',    :description => '', :function => nil },

			'main'       => { :hotkey => '^M',  :shortname => 'Main Menu',   :menuname => 'Main Menu',   :description => 'Main Menu', :function => :main },
			'create'     => { :hotkey => 'c',   :shortname => 'Create',      :menuname => 'Create Task', :description => 'Create a task', :function => :create },
			'index'      => { :hotkey => 'i',   :shortname => 'Index',       :menuname => 'Task Index',  :description => 'View tasks in current folder', :function => :index },


			'create_task'=> { :hotkey => '^X',  :shortname => 'Create',    :menuname => 'Create a Task', :description => '', :function => :create_task},
			'create_help'=> { :hotkey => '^G',  :shortname => 'Get Help',    :menuname => 'Get Syntax Help', :description => 'Get help using Taskman', :function => :create_help},

			# Actions related to messages when a person tries to move
			# beyond widget/page/window limits
			'top_list'=> { :hotkey => 'UP',  :shortname => '',    :menuname => '', :description => '', :function => :top_list},
			'bottom_list'=> { :hotkey => 'DOWN',  :shortname => '',    :menuname => '', :description => '', :function => :bottom_list},
			'top_header'=> { :hotkey => 'UP',  :shortname => '',    :menuname => '', :description => '', :function => :top_header},
			#'bottom_page'=> { :hotkey => 'DOWN',  :shortname => '',    :menuname => '', :description => ''},

			'postpone'           => { :hotkey => '^O',   :shortname => 'Postpone',         :description => '', :function => :postpone},
			'cancel'             => { :hotkey => '^C',   :shortname => 'Cancel',           :description => '', :function => :cancel},

			# Testing shortcuts
			'inc_folder_count'   => { :hotkey => 'SR',   :shortname => 'Folder Cnt+1',     :description => '', :function => :inc_folder_count },
			'all_widgets_hash'   => { :hotkey => 'SF',   :shortname => 'All Children',     :description => '', :function => :all_widgets},
			'parent_names'       => { :hotkey => '^P',   :shortname => 'Parent Tree',      :description => '', :function => :parent_names},

			# Various
			'toggle_timing_options'=> { :description => 'Toggle Timing Options', :function => :toggle_timing_options},
			'toggle_remind_options'=> { :description => 'Toggle Remind Options', :function => :toggle_remind_options},
		}

		def initialize arg= {}
			name= arg[:name]= arg[:name].to_s
			if name.length> 0
				@name= name
			end
			@hotkey= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[name][:hotkey]
			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[name][:shortname]
			@menuname= arg.has_key?( :menuname) ? arg.delete( :menuname): @@Menus[name][:menuname]
			@description= arg.has_key?( :description) ? arg.delete( :description).truncate: @@Menus[name][:description].truncate

			# Function to execute can be specified in a parameter or come from a default.
			# If none of that is specified, it defaults to a function named the same as
			# the menuaction itself.
			@function= arg.has_key?( :function) ? arg.delete( :function) : @@Menus[name][:function]

			super
		end

		def menu_text
			# 2 - 5 - 15 - 4" - "2 - 33
			"%2s     %-15s    -  %-33s" % [ @hotkey.upcase, ( @menuname|| @shortname).upcase, @description]
		end

		################################### Functions ###################################

		def top_list arg= {}
			w= arg[:window]
			if wh= w.all_widgets_hash['status']
				wh.var_text= '[Already at top of list]'
			end
		end
		def bottom_list arg= {}
			w= arg[:window]
			if wh= w.all_widgets_hash['status']
				wh.var_text= '[Already at bottom of list]'
			end
		end
		def top_header arg= {}
			w= arg[:window]
			if wh= w.all_widgets_hash['status']
				wh.var_text= "[ Can't move beyond top of header ]"
			end
		end
		def bottom_page arg= {}
			w= arg[:window]
			if wh= w.all_widgets_hash['status']
				wh.var_text= "[ Can't move beyond bottom of page ]"
			end
		end

		def quit arg= {}
			w= arg[:window]
			pfl w.widgets_hash.keys
			if w.widgets_hash['status']
				puts :YES
			end
			Stfl.reset
			puts "Taskman finished."
			exit 0
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

		############################### Testing Functions ################################

#		def inc_folder_count arg= {}
#			$app.screen.all_widgets_hash['folder_count'].var_text+= 1
#			#pfl $app.screen.all_widgets_hash['folder_count'].parent_tree.map { |x| x.name }
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
			$app.exec( :window => 'main')
		end
		def create arg= {}
			$app.exec( :window => 'create')
		end
		def index arg= {}
			$app.exec( :window => 'index')
		end

		def create_task arg= {}

			i= Item.new
			wh= all_widgets_hash

			begin

				[
					:subject,
					:start,
					:end,
					:time,
					:omit_shift,
					:remind_shift,
					:message
				].each do |f|
					v= ( $app.ui.get "#{f.to_s}_text").strip
					next unless v.length> 0
					i.send "parse_#{f}", v
				end
				[
					:due,
					:omit,
					:remind,
				].each do |f|
					list= ( $app.ui.get "#{f}_text").split /,/
					list.each do |v|
						v.strip!
						next unless v.length> 0
						i.send "parse_#{f}", v
					end
				end

				id= ( Time.now.to_i.to_s+ Time.now.usec.to_s).to_i
				i.id= id

				$tasklist[id]= i
				$tasklist.save

			rescue Exception => e
				pfl e
			end
		end

		def toggle_timing_options arg= {}
			w= arg[:window]
			wh= w.all_widgets_hash
			wh['timing'].toggle
			v= wh['timing'].var_value
			wh['timing_options'].var__display= v
		end

		def toggle_remind_options arg= {}
			w= arg[:window]
			wh= w.all_widgets_hash
			wh['remind'].toggle
			v= wh['remind'].var_value
			wh['remind_options'].var__display= v
		end

#		def postpone arg= {}
#		end
#
#		def cancel arg= {}
#		end
#
#		def parent_names arg= {}
#			w= arg[:widget]
#			pt= w.parent_tree
#			pfl pt.map{ |x| x.name}
#		end
#
	end

	def create_help arg= {}
		puts :BABY_BOY
	end

	def save_tasklist
		$tasklist.save
	end

end
