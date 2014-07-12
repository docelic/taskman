module TASKMAN

	class Theme::Window::Colortest < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Colortest::Head.new( :name => :head)
			self<< Theme::Window::Colortest::Body.new( :name => :body)
			self<< Theme::Window::Colortest::Status.new( :name => :status)
			self<< Theme::Window::Colortest::Menu.new( :name => :menu)
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
				:folder_list,
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
