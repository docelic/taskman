# File implementing basic screen functions
# ('Screen' being all the visible area in a terminal window)

module TASKMAN

	class Screen < StflBase

		def main_loop
			loop do
				event= $app.stfl.run 0
				focus= $app.stfl.get_focus

				if m= @children_hash[:menu] and a= m.hotkeys_hash[event] and f= a.function
					f.yield( event)
				end
			end
		end

	end

end
