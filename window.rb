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

				#pfl :KEYPRESS, focus, event

				# Next if the event has been handled by the widget
				next if event.length== 0

				# Handle specific events in a generic way
				if event== 'SLEFT'
					@show_next_key= true
				elsif @show_next_key
					pfl focus, event
					@show_next_key= false
				end

				# Support windows to have multiple menus, and search
				# in all of them for a match
				if menus= @widgets_hash.keys.grep( /menu/)
					menus.each do |mn|
						m= @widgets_hash[mn]
						if a= m.hotkeys_hash[event]
							if Symbol=== f= a.function
								a.send( f, :screen => self, :menu => m, :action => a, :function => f, :event => event)
							elsif Proc=== f= a.function
								f.yield( :screen => self, :menu => m, :action => a, :function => f, :event => event)
							end
						end
					end
				end

				# Events reaching here are unhandled/default. For example,
				# pressing RIGHT when already at the end of the input box
				# text etc.

			end
		end

	end

end
