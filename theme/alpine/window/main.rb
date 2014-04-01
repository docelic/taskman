module TASKMAN

	class Theme::Window::Main < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Main::Head.new( :name => :head)
			self<< Theme::Window::Main::Body.new( :name => :body)
			self<< Theme::Window::Main::Status.new( :name => :status)

			m1= Theme::Window::Main::Menu.new( :name => :menu1, '.display' => 1)
			m1.add_action(
				#:'', #:help,
				#:'', #:quit,
				:create,
				:index,
				:listfolders,
#				:'',
#				:prevcmd,
#				:'',
				:'', #:relnotes,
				:'',
				:'',
				#:'',
				:tablebr, ##
				:quit, #:other,
				:'',
				:gotofolder,
#				:hotkey_in,
#				:nextcmd,
				:'',
				:'', #:kblock,
				:'',
			)

#			m2= Theme::Window::Main::Menu.new( :name => :menu2, '.display' => 0)
#			m2.add_action(
#				:'', #:help2,
#				:quit,
#				:listfolders,
#				:index,
#				:'', #:setup
#				:'', #:role,
#				:tablebr, ##
#				:other2,
#				:create,
#				:gotofolder,
#				:'', #:journal,
#				:'', #:addrbook,
#				:'',
#			)

			self<< m1
#			self<< m2
		end

	end

end
