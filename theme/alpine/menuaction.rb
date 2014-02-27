module TASKMAN

	class Theme::MenuAction < MenuAction

		def setup_widgets
			name= [ :menu, @name].join '_'
			hotkey_name= [ name, 'hotkey'].join '_'
			shortname_name= [ name, 'shortname'].join '_'
			w= @hotkey.length
			self<< Label.new( :name => hotkey_name,    '.expand' => '0', '.width' =>          w, :@style_normal => 'bg=red,fg=white',   :text => @hotkey)
			self<< Label.new(                          '.expand' => '0', '.width' =>  1+ (1- w), :@style_normal => 'bg=black,fg=white', :text => ' ') #, '.display' => ( w== 1 ? 1 : 0))
			self<< Label.new( :name => shortname_name, '.expand' => 'h', '.width' =>         12, :@style_normal => 'bg=black,fg=white', :text => @shortname)
		end

	end

end
