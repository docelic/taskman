# File implementing basic screen functions
# ('Screen' being all the visible area in a terminal window)

module TASKMAN

	class Screen < StflBase

		def main_loop
			loop do
				event = $app.stfl.run 0
				focus = $app.stfl.get_focus
			end
		end

	end

end
