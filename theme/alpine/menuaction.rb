module TASKMAN

	class Theme::MenuAction < MenuAction

		def to_stfl
			name= [ :menu, @name].join '_'
			hotkey_name= [ name, 'hotkey'].join '_'
			shortname_name= [ name, 'shortname'].join '_'
			w= @hotkey.length
			
			a= []
			a<< Label.new( :name => hotkey_name,    '.expand' => '0', '.width' =>          w, :text => @hotkey)
			a<< Label.new(                          '.expand' => '0', '.width' =>  1+ (1- w), :text => ' ') #, '.display' => ( w== 1 ? 1 : 0))
			a<< Label.new( :name => shortname_name, '.expand' => 'h', '.width' =>         12, :text => @shortname)

			a.to_stfl
		end

	end

end
