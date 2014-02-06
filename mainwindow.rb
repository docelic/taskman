
module TASKMAN
	class MainWindow < Vbox

		def initialize *arg
			super

			self<< h= Hbox.new( :'.expand' => '0', :@style_normal => 'bg=white,fg=black')
			h<< Label.new( :'.tie' => 'l', :'.expand' => '0', :text => '"  TASKMAN 0.01(26)    "')
			h<< Label.new( :'.tie' => 'l', :name => 'form_name', :text => '"MAIN MENU"')
			h<< Label.new( :'.tie' => 'r', :text => '"Folder: "')
			h<< Label.new( :'.tie' => 'l', :name => 'current_folder', :text => '"INBOX"')
			h<< Label.new( :'.tie' => 'r', :name  => 'folder_count', :text => '1')
			h<< Label.new( :'.tie' => 'l', :name => 'folder_unit', :'.expand' => '0', :text => '" Items  "')
		end
	end
end
