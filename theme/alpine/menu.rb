module TASKMAN

	class Menu < Widget

		def initialize *arg
			super()

			v= Vbox.new( :'.expand' => 0, :'.height' => '2', :@style_normal => 'bg=red,fg=white')

			t1= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=blue,fg=white', :'.display' => 1)
			t2= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=red,fg=white', :'.display' => 0)
			pos= 0
			[ t1, t2].each do |t|
				2.times do |i|
					4.times do
						name= [ 'menu', pos].join '_'
						hotkey_name= [ name, 'hotkey', 'text'].join '_'
						shortname_name= [ name, 'shortname', 'text'].join '_'
						t<< Label.new( :'.expand' => '0', :@style_normal => 'bg=red,fg=white', :"text[#{hotkey_name}]" => '')
						t<< Label.new( :'.expand' => 'h', :@style_normal => 'bg=black,fg=white', :"text[#{shortname_name}]" => '')
						pos+= 1
					end
					t<< Tablebr.new if i== 0
				end
			end

			v<< t1
			v<< t2

			self<< v

		end
	
	end

end
