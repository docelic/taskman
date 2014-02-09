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
			'quit'       => { :hotkey => 'Q',   :shortname => 'Quit Taskman', :description => '', :function => :quit },
			'listfolders'=> { :hotkey => 'L',   :shortname => 'ListFldrs',    :description => '', :function => nil },
			'index'      => { :hotkey => 'I',   :shortname => 'Index',        :description => '', :function => nil },
			'setup'      => { :hotkey => 'S',   :shortname => 'ListFldrs',    :description => '', :function => nil },
			'role'       => { :hotkey => '#',   :shortname => 'Role',         :description => '', :function => nil },
			'create'     => { :hotkey => 'C',   :shortname => 'Create',       :description => '', :function => nil },
			'gotofolder' => { :hotkey => 'G',   :shortname => 'GotoFldr',     :description => '', :function => nil },
			'journal'    => { :hotkey => 'J',   :shortname => 'Journal',      :description => '', :function => nil },
			'addrbook'   => { :hotkey => 'A',   :shortname => 'AddrBook',     :description => '', :function => nil },
		}

		def initialize arg= {}
			@name= arg[:name]= arg[:name].to_s
			@hotkey= arg.has_key?( :hotkey) ? arg.delete( :hotkey): @@Menus[@name][:hotkey]
			@shortname= arg.has_key?( :shortname) ? arg.delete( :shortname): @@Menus[@name][:shortname]
			@description= arg.has_key?( :description) ? arg.delete( :description): @@Menus[@name][:description]
			@function= arg.has_key?( :function) ? arg.delete( :function): @@Menus[@name][:function]

			super

			setup_children
		end

		def setup_children
			name= [ :menu, @name].join '_'
			hotkey_name= [ name, 'hotkey'].join '_'
			shortname_name= [ name, 'shortname'].join '_'
			self<< Label.new( :name => hotkey_name,    '.expand' => '0', :@style_normal => 'bg=red,fg=white',   :text => @hotkey)
			self<< Label.new( :name => shortname_name, '.expand' => '0', :@style_normal => 'bg=black,fg=white', :text => @shortname)
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

	end

end
