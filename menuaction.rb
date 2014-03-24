module TASKMAN

	class MenuAction < Widget

		attr_accessor :name, :hotkey, :shortname, :description, :function
		
		# TODO move this to outside file
		@@Menus= {
			# To have multiple "same" menus, you must use different names
			'help'       => { :hotkey => '?',   :shortname => 'Help',         :description => '', :function => Proc.new { puts "YEHUDA KATZ!" }},
			'help2'      => { :hotkey => '?',   :shortname => 'Help',         :description => '', :function => Proc.new { puts "YEHUDA KATZ!" }},

			# For the empty slot, no need to use a different name even if
			# it appears multiple times, because empty name results in the
			# name being auto-generated
			''           => { :hotkey => '',    :shortname => '',             :description => '', :function => nil }, # Empty one

			'prevcmd'    => { :hotkey => 'p',   :shortname => 'PrevCmd',      :description => '', :function => nil },
			'relnodes'   => { :hotkey => 'r',   :shortname => 'RelNotes',     :description => '', :function => nil },

			'other'      => { :hotkey => 'o',   :shortname => 'OTHER CMDS',   :description => '', :function => :menu_next_page },
			'other2'     => { :hotkey => 'o',   :shortname => 'OTHER CMDS',   :description => '', :function => :menu_next_page },

			'hotkey_in'  => { :hotkey => '>',   :shortname => '',             :description => '', :function => nil },
			'hotkey_out' => { :hotkey => '<',   :shortname => '',             :description => '', :function => nil },
			'nextcmd'    => { :hotkey => 'n',   :shortname => 'NextCmd',      :description => '', :function => nil },
			'kblock'     => { :hotkey => 'k',   :shortname => 'KBLock',       :description => '', :function => nil },
			'quit'       => { :hotkey => 'q',   :shortname => 'Quit',         :description => '', :function => :quit },
			'listfolders'=> { :hotkey => 'l',   :shortname => 'ListFldrs',    :description => '', :function => nil },
			'index'      => { :hotkey => 'i',   :shortname => 'Index',        :description => '', :function => nil },
			'setup'      => { :hotkey => 's',   :shortname => 'Setup',        :description => '', :function => nil },
			'role'       => { :hotkey => '#',   :shortname => 'Role',         :description => '', :function => nil },
			'create'     => { :hotkey => 'c',   :shortname => 'Create',       :description => '', :function => :create },
			'gotofolder' => { :hotkey => 'g',   :shortname => 'GotoFldr',     :description => '', :function => nil },
			'journal'    => { :hotkey => 'j',   :shortname => 'Journal',      :description => '', :function => nil },
			'addrbook'   => { :hotkey => 'a',   :shortname => 'AddrBook',     :description => '', :function => nil },


			'get_create_help'    => { :hotkey => '^G',   :shortname => 'Get Help',         :description => '', :function => :get_create_help},
			'postpone'           => { :hotkey => '^O',   :shortname => 'Postpone',         :description => '', :function => :postpone},
			'cancel'             => { :hotkey => '^C',   :shortname => 'Cancel',           :description => '', :function => :cancel},

			# Testing shortcuts
			'inc_folder_count'   => { :hotkey => 'SR',   :shortname => 'Folder Cnt+1',     :description => '', :function => :inc_folder_count },
			'all_widgets_hash'   => { :hotkey => 'SF',   :shortname => 'All Children',     :description => '', :function => :all_widgets},
			'parent_names'       => { :hotkey => '^P',   :shortname => 'Parent Tree',      :description => '', :function => :parent_names},
		}

		def initialize arg= {}
			name= arg[:name]= arg[:name].to_s
			if name.length> 0
				@name= name
			end
			@hotkey= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[name][:hotkey]
			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[name][:shortname]
			@description= arg.has_key?( :description) ? arg.delete( :description): @@Menus[name][:description]
			@function= arg.has_key?( :function) ? arg.delete( :function): @@Menus[name][:function]

			super
		end

		################################### Functions ###################################

		def quit arg= {}
			Stfl.reset
			puts "Taskman finished -- Closed empty folder \"INBOX\""
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
#		def create arg= {}
#		end
#
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

end
