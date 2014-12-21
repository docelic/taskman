module TASKMAN

	class Theme::MenuAction < MenuAction

		def initialize arg= {}
			super
			name= [ :menu, @name].join '_'
			@hotkey_name= [ name, 'hotkey'].join '_'
			@spacer_name= [ name, 'hspace'].join '_'
			@shortname_name= [ name, 'shortname'].join '_'

			self<< Hotkey.new(    :name=> @hotkey_name,    :'.expand'=> '0', :'.width'=> @hotkey_label.length, :text => @hotkey_label.upcase, :'.tie'=>'rt')
			self<< Hspace.new(    :name=> @spacer_name,    :'.expand'=> '0', :'.width'=> 1,              :text => '')
			self<< Shortname.new( :name=> @shortname_name, :'.expand'=> 'h', :'.width'=> 12,             :text => @shortname)
		end
	end

	# Added here just so that the style resolution mechanism
	# would automatically allow us to use selectors named
	# "menu @hotkey" and "menu @shortname", instead of just
	# "menu @label".
	class Hotkey < Label
	end
	class Shortname < Label
	end
end
