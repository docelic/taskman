module TASKMAN

	class Theme::MenuAction < MenuAction

		def initialize *arg
			super
			name= [ :menu, @name].join '_'
			@hotkey_name= [ name, 'hotkey'].join '_'
			@spacer_name= [ name, 'spacer'].join '_'
			@shortname_name= [ name, 'shortname'].join '_'

			w= if @hotkey.length> 1 then @hotkey.length else 1 end
			self<< Label_hotkey.new( :name => @hotkey_name,    '.expand' => '0', '.width' =>          w, :text => @hotkey.uc)
			self<< Label_spacer.new( :name => @spacer_name,    '.expand' => '0', '.width' =>  1+ (1- w), :text => '')
			self<< Label_shortname.new( :name => @shortname_name, '.expand' => 'h', '.width' => 12,      :text => @shortname)
		end

	end

end
