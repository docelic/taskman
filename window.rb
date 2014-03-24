# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# Or another way of thinking about it is a portion of the
# screen. (For example, the alpine theme consists of a 'screen'
# with header, body, status and menu windows)

module TASKMAN

	class Window < StflBase

		attr_reader :actions

		def main_loop
			loop do
				event= $app.ui.run 0
				focus= $app.ui.get_focus

				if $opts['debug-keys']
					pfl "Window #{@name}, widget #{focus}, key #{event}"
				end

				# Next if the event has been handled by the widget
				next if event.length== 0

				# Handling the keypress goes by checking the hotkeys associated
				# with the widget itself, then with the window menus, and then
				# with the parent widgets of the one receiving the keypress.
				# First match is executed.
				widget= all_widgets_hash()[focus]
				[ widget, *menus(), *widget.parent_tree()].each do |w|
					if a= w.hotkeys_hash[event]
						if Symbol=== f= a.function
							a.send( f, :window => self, :widget => widget, :action => a, :function => f, :event => event)
							break
						elsif Proc=== f= a.function
							f.yield( :window => self, :widget => widget, :action => a, :function => f, :event => event)
							break
						end
					end
				end

				## Handle specific events in a generic way
				#if event== 'SLEFT'
				#	@show_next_key= true
				#elsif @show_next_key
				#	pfl focus, event
				#	@show_next_key= false
				#end

				# Events reaching here are unhandled/default. For example,
				# pressing RIGHT when already at the end of the input box
				# text etc.

			end
		end

		def menus
			@widgets.select{ |w| w.name=~ /^menu/}
		end

	end

end
