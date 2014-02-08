module TASKMAN

	class Theme::MenuAction < MenuAction

		def setup_children
			name= [ :menu, @name].join '_'
			hotkey_name= [ name, 'hotkey'].join '_'
			shortname_name= [ name, 'shortname'].join '_'
			self<< Label.new( :name => hotkey_name,    '.expand' => '0', :@style_normal => 'bg=red,fg=white', :text => @hotkey)
			self<< Label.new(                          '.expand' => '0', :@style_normal => 'bg=black,fg=white', :text => ' ')
			self<< Label.new( :name => shortname_name, '.expand' => 'h', :@style_normal => 'bg=black,fg=white', :text => @shortname)
		end

	end

end
