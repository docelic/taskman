module TASKMAN

	class Theme::Menu < Menu

		def add_action *arg
			arg.each do |a|
				self<< Theme::MenuAction.new( :name => a.to_s)
			end
		end

		def to_stfl
			v= Vbox.new( :'.expand' => 0, :'.height' => '2', :@style_normal => 'bg=red,fg=white')
			t= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=blue,fg=white', :'.display' => 1)

			pos= 0
			2.times do |i|
				4.times do
					t<< ( @children[pos]|| Theme::MenuAction.new( :name => ''))
					pos+= 1
				end
				t<< Tablebr.new if i== 0
			end
			v<< t

			v.to_stfl
		end

		# Need an override here for taking into account the @hotkeys_hash
		def << arg
			@children<< arg
			@children_hash[arg.name]= arg
			@hotkeys_hash[arg.hotkey]= arg
		end
		def >> arg
			@children>> arg
			@children_hash>> arg.name
			@hotkeys_hash>> arg.name
		end
	
	end

end
