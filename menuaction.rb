module TASKMAN

	class MenuAction < Widget

		attr_accessor :name, :hotkey, :shortname, :description, :function
		
		# TODO move this to outside file
		@@Menus= {
			'help'       => { :hotkey => '?',   :shortname => 'Help',         :description => '', :function => Proc.new { puts "YEHUDA KATZ!" }},
			''           => { :hotkey => '',    :shortname => '',             :description => '', :function => nil }, # Empty one
			'prevcmd'    => { :hotkey => 'P',   :shortname => 'PrevCmd',      :description => '', :function => nil },
			'relnodes'   => { :hotkey => 'R',   :shortname => 'RelNotes',     :description => '', :function => nil },
			'other'      => { :hotkey => 'O',   :shortname => 'OTHER CMDS',   :description => '', :function => :menu_next_page },
			'hotkey_in'  => { :hotkey => '>',   :shortname => '',             :description => '', :function => nil },
			'hotkey_out' => { :hotkey => '<',   :shortname => '',             :description => '', :function => nil },
			'nextcmd'    => { :hotkey => 'N',   :shortname => 'NextCmd',      :description => '', :function => nil },
			'kblock'     => { :hotkey => 'K',   :shortname => 'KBLock',       :description => '', :function => nil },
			'quit'       => { :hotkey => '^W',  :shortname => 'Quit Taskman', :description => '', :function => :quit },
			'listfolders'=> { :hotkey => 'L',   :shortname => 'ListFldrs',    :description => '', :function => nil },
			'index'      => { :hotkey => 'I',   :shortname => 'Index',        :description => '', :function => nil },
			'setup'      => { :hotkey => 'S',   :shortname => 'Setup',        :description => '', :function => nil },
			'role'       => { :hotkey => '#',   :shortname => 'Role',         :description => '', :function => nil },
			'create'     => { :hotkey => 'C',   :shortname => 'Create',       :description => '', :function => :create },
			'gotofolder' => { :hotkey => 'G',   :shortname => 'GotoFldr',     :description => '', :function => nil },
			'journal'    => { :hotkey => 'J',   :shortname => 'Journal',      :description => '', :function => nil },
			'addrbook'   => { :hotkey => 'A',   :shortname => 'AddrBook',     :description => '', :function => nil },


			'get_create_help'    => { :hotkey => '^G',   :shortname => 'Get Help',         :description => '', :function => :get_create_help},
			'create'             => { :hotkey => '^X',   :shortname => 'Create',           :description => '', :function => :create},
			'postpone'           => { :hotkey => '^O',   :shortname => 'Postpone',         :description => '', :function => :postpone},
			'cancel'             => { :hotkey => '^C',   :shortname => 'Cancel',           :description => '', :function => :cancel},

			# Testing shortcuts
			'inc_folder_count'   => { :hotkey => 'SR',   :shortname => 'Folder Cnt+1',     :description => '', :function => :inc_folder_count },
			'all_widgets_hash'   => { :hotkey => 'SF',   :shortname => 'All Children',     :description => '', :function => :all_widgets},
			'parent_names'       => { :hotkey => '^P',   :shortname => 'Parent Tree',      :description => '', :function => :parent_names},
		}

		def initialize arg= {}
			@name= arg[:name]= arg[:name].to_s
			@hotkey= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[@name][:hotkey]
			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[@name][:shortname]
			@description= arg.has_key?( :description) ? arg.delete( :description): @@Menus[@name][:description]
			@function= arg.has_key?( :function) ? arg.delete( :function): @@Menus[@name][:function]

			super

			#setup_widgets
		end

		################################### Functions ###################################

		def quit arg= {}
			Stfl.reset
			puts "Taskman finished -- Closed empty folder \"INBOX\""
			exit 0
		end

		def menu_next_page arg= {}
			arg[:menu].next_page
			arg[:menu].redraw
		end

		############################### Testing Functions ################################

		def inc_folder_count arg= {}
			$app.screen.all_widgets_hash['folder_count'].var_text+= 1
			#pfl $app.screen.all_widgets_hash['folder_count'].parent_tree.map { |x| x.name }
		end
		# This cannot be named "all_widgets_hash" or endless loop will ensue :)
		# (Due to the widget above being called "all_widgets_hash" as well)
		def all_widgets arg= {}
			pfl $app.screen.all_widgets_hash.keys
		end

		def get_create_help arg= {}
		end

		def create arg= {}
		end

		def postpone arg= {}
		end

		def cancel arg= {}
		end

		def parent_names arg= {}
			w= arg[:widget]
			pt= w.parent_tree
			pfl pt.map{ |x| x.name}
		end

	end

end
