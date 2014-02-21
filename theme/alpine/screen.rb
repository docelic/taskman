module TASKMAN

	class Theme::Screen < Screen

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Head.new( :name => :head)
			self<< Theme::Body.new( :name => :body, :body => 'Colors' )
			self<< Theme::Status.new( :name => :status)
			self<< Theme::Menu.new( :name => :menu)

			@widgets_hash[:menu].add_action(
				:help,
				:'',
				:prevcmd,
				:'',
				:relnodes,
				:'',
				:other,
				:hotkey_in,
				:nextcmd,
				:'',
				:kblock,
				:'',
				:help,
				:quit,
				:listfolders,
				:index,
				:setup,
				:role,
				:other,
				:create,
				:gotofolder,
				:journal,
				:addrbook,
				:'',
				:inc_folder_count,
				:all_widgets_hash,
			)
		end

	end

end
