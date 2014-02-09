module TASKMAN

	class Theme::Menu < Menu

		def initialize *arg
			super

			@widget= 'vbox'
			@page_size= 12
		end

		def add_action *arg
			arg.each do |a|
				self<< Theme::MenuAction.new( :name => a.to_s)
			end
		end

		def to_stfl
			v= Vbox.new( :name => :menu, :'.expand' => 0, :'.height' => '2', :@style_normal => 'bg=red,fg=white')
			t= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=blue,fg=white', :'.display' => 1)

			pos= 0
			2.times do |i|
				6.times do
					t<< ( @children[@offset+ pos])
					pos+= 1
				end
				t<< Tablebr.new if i== 0
			end
			v<< t

			v.to_stfl
		end
	
	end

end
