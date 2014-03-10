module TASKMAN

	class Menu < StflBase

		attr_reader :actions, :hotkeys_hash

		def initialize *arg
			super

			@hotkeys_hash= {}
		end

		# Overriding here to take into account the @hotkeys_hash
		def << arg
			super
			if MenuAction=== arg
				@hotkeys_hash[arg.hotkey]= arg
			end
		end
		def >> arg
			super
			if MenuAction=== arg
				@hotkeys_hash>> arg.name
			end
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
