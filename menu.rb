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
			if @offset>= @widgets.size
				@offset= 0
			end
		end

		# Overriding here to take into account the @hotkeys_hash
		def << arg
			super
			@hotkeys_hash[arg.hotkey]= arg
		end
		def >> arg
			super
			@hotkeys_hash>> arg.name
		end

		def add_action *arg
			arg.each do |a|
				if ma= Theme::MenuAction.new( :name => a.to_s)
					self<< ma
				else
					$stderr.puts "Menu action #{a.to_s} does not exist; skipping."
				end
			end
		end

	end

end
