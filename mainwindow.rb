module TASKMAN
	class MainWindow < Window

		@@menu= [
			MenuAction.new( :test)
		]

		def initialize *arg
			super

			pfl @@menu
			exit

			self<< h= Hbox.new( :'.expand' => '0', :@style_normal => 'bg=white,fg=black')
			h<< Label.new( :'.tie' => 'l', :'.expand' => '0', :text => '  TASKMAN 0.01(26)    ')
			h<< Label.new( :'.tie' => 'l', :'text[form_name_text]' => 'MAIN MENU')
			h<< Label.new( :'.tie' => 'r', :text => 'Folder: ')
			h<< Label.new( :'.tie' => 'l', :'text[folder_name_text]' => 'INBOX')
			h<< Label.new( :'.tie' => 'r', :'text[folder_count_text]' => '1')
			h<< Label.new( :'.tie' => 'l', :'.expand' => '0', :'text[folder_unit_text]' => ' Items  ')

			self<< v= Vbox.new( :@style_normal => 'bg=black,fg=white')

			self<< s= Hbox.new( :'.expand' => 'h', :@style_normal => 'bg=red,fg=white')
			s<< Label.new( :'.expand' => '0', :@style_normal => 'bg=blue,fg=white', :'text' => ' ')
			s<< Label.new( :@style_normal => 'bg=black,fg=white', :'text' => '')
			s<< Label.new( :'.expand' => '0', :@style_normal => 'bg=blue,fg=white', :'text[status_text]' => '')
			s<< Label.new( :@style_normal => 'bg=black,fg=white', :'text' => '')

			self<< v= Vbox.new( :'.expand' => 0, :'.height' => '2', :@style_normal => 'bg=red,fg=white')

			v<< t= Table.new( :'.expand' => 'h', :'.height' => '1', :@style_normal => 'bg=red,fg=white')
			2.times do |i|
				4.times do |j|
					name= [ 'menu', ( i+1)* (j+1)].join '_'
					hotkey_name= [ name, 'hotkey', 'text'].join '_'
					description_name= [ name, 'description', 'text'].join ' '
					t<< Label.new( :'.expand' => '0', :@style_normal => 'bg=yellow,fg=white', :"text[#{hotkey_name}]" => '')
					t<< Label.new( :'.expand' => 'h', :@style_normal => 'bg=black,fg=white', :"text[#{description_name}]" => '')
				end
				t<< Tablebr.new if i== 0
			end
		end
	end
end
