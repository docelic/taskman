require 'theme/alpine/menuaction'

module TASKMAN

	class Theme::Menu < Menu

		def initialize *arg
			super()

			v= Vbox.new( :'.expand' => 0, :'.height' => '2', :@style_normal => 'bg=red,fg=white')
			t= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=blue,fg=white', :'.display' => 1)

			pos= 0
			2.times do |i|
				4.times do
					t<< Theme::MenuAction.new( :name => arg[pos]|| '')
					pos+= 1
				end
				t<< Tablebr.new if i== 0
			end

			v<< t
			self<< v
		end
	
	end

end
