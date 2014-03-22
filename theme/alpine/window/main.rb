module TASKMAN

	class Theme::Window::Main < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Head.new( :name => :head)
			self<< Theme::Window::Main::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)

			m1= Theme::Window::Main::Menu.new( :name => :menu1)
			m1.add_action(
				:parent_names,
#				:help,
#				:prevcmd,
#				:relnodes,
#				:other,
#				:hotkey_in,
#				:nextcmd
				)

#			m2= Theme::Window::Main::Menu.new( :name => :menu2)
			#m2.add_action(
#				:kblock,
#				:help,
				#:quit,
#				:listfolders,
#				:index,
#				:setup)
		#		:role,
		#		:other,
		#		:create,
		#		:gotofolder,
		#		:journal,
		#		:addrbook,
		#		#:'',
		#		#:inc_folder_count,
		#		#:all_widgets_hash,
			#)

			self<< m1
#			self<< m2
		end

	end

end
