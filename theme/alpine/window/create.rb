module TASKMAN

	class Theme::Window::Create < Theme::Window

		def initialize *arg
			super

			@widget= 'vbox'

			self<< Theme::Window::Create::Head.new( :name => :head)
			self<< Theme::Window::Create::Body.new( :name => :body)
			self<< Theme::Window::Create::Status.new( :name => :status)
			self<< Theme::Window::Create::Menu.new( :name => :menu)
			@widgets_hash[:menu].add_action(
				:get_create_help,
				:create,
				:'',
				:'',
				:inc_folder_count,
				:postpone,

				:cancel,
				:'',
				:'',
				:'',
				:'',
				:'',
			)
		end

	end

end
