module TASKMAN

	class Head < Window

		def initialize *arg
			super()
			h= Hbox.new( :'.expand' => '0', :@style_normal => 'bg=white,fg=black')
			h<< Label.new( :'.tie' => 'l', :'.expand' => '0', :text => '  TASKMAN 0.01(26)    ')
			h<< Label.new( :'.tie' => 'l', :'text[form_name_text]' => 'MAIN MENU')
			h<< Label.new( :'.tie' => 'r', :text => 'Folder: ')
			h<< Label.new( :'.tie' => 'l', :'text[folder_name_text]' => 'INBOX')
			h<< Label.new( :'.tie' => 'r', :'text[folder_count_text]' => '1')
			h<< Label.new( :'.tie' => 'l', :'.expand' => '0', :'text[folder_unit_text]' => ' Items  ')

			self<< h

		end

	end

end
