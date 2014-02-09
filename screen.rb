# File implementing basic screen functions
# ('Screen' being all the visible area in a terminal window)

module TASKMAN

	class Screen < StflBase

		def main_loop
			pos= 0
			loop do
				event= $app.ui.run 0
				focus= $app.ui.get_focus

				if m= @children_hash[:menu] and a= m.hotkeys_hash[event]
					if Symbol=== f= a.function
						a.send( f, :screen => self, :menu => m, :action => a, :function => f, :event => event)
					elsif Proc=== f= a.function
						f.yield( :screen => self, :menu => m, :action => a, :function => f, :event => event)
					end
				end

				pos+= 1
				#pfl $app.screen.children_hash['widget_0'] #.set( 'text', pos)
			end
		end

	end

end
