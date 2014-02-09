# File implementing generic menu functions.

module TASKMAN

	class Menu < StflBase

		attr_reader :actions, :hotkeys_hash

		def initialize *arg
			super

			@hotkeys_hash= {}
			@page_size= 0
			@offset= 0
		end

		def next_page
			@offset+= @page_size
			if @offset>= @children.size
				@offset= 0
			end
		end

		# Need an override here for taking into account the @hotkeys_hash
		def << arg
			@children<< arg
			@children_hash[arg.name]= arg
			@hotkeys_hash[arg.hotkey]= arg
		end
		def >> arg
			@children>> arg
			@children_hash>> arg.name
			@hotkeys_hash>> arg.name
		end

	end

end
