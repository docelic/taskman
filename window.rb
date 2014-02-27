# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# Or another way of thinking about it is a portion of the
# screen. (For example, the alpine theme consists of a 'screen'
# with header, body, status and menu windows)

module TASKMAN

	class Window < StflBase

		attr_reader :actions

		#def initialize *arg
		#	@widget= :vbox

		#	super
		#end

		def main_loop
			loop do
				event= $app.ui.run 0
				focus= $app.ui.get_focus

				if event== 'SLEFT'
					@show_next_key= true
				elsif @show_next_key
					pfl event
					@show_next_key= false
				end

				if m= @widgets_hash[:menu] and a= m.hotkeys_hash[event]
					if Symbol=== f= a.function
						a.send( f, :screen => self, :menu => m, :action => a, :function => f, :event => event)
					elsif Proc=== f= a.function
						f.yield( :screen => self, :menu => m, :action => a, :function => f, :event => event)
					end
				end
			end
		end

	end

end
