module TASKMAN

	class Theme::Window::Main < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Head.new( :name => :head)
			self<< Theme::Window::Main::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)

			m= Theme::Window::Main::Menu.new( :name => :menu)
			m.add_action(
				:help,
				:prevcmd,
				:relnodes,
				:other,
				:hotkey_in,
				:nextcmd,
				:kblock,
				:help,
				:quit,
				:listfolders,
				:index,
				:setup,
		#		:role,
		#		:other,
		#		:create,
		#		:gotofolder,
		#		:journal,
		#		:addrbook,
		#		#:'',
		#		#:inc_folder_count,
		#		#:all_widgets_hash,
			)

			self<< m
		end

	end

end
