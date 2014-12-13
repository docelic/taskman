# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# Or another way of thinking about it is a portion of the
# screen. (For example, the alpine theme consists of a 'screen'
# with header, body, status and menu windows)

module TASKMAN

	class Window < StflBase

		def main_loop code= 0
			loop do
				event= $app.ui.run code
				focus= $app.ui.get_focus

				# Handling the keypress goes by checking the hotkeys associated
				# with the widget itself, then with the window menus, and then
				# with the parent widgets of the one receiving the keypress.
				# First match is executed.
				wh= all_widgets_hash()
				widget= wh[focus]

				# Searching for actions to execute (and doing other work)
				# only makes sense if some widget was focused
				if focus and widget
					if widget.widget== 'list'
						w= $app.ui.get "#{widget.name}_pos_name"
						unless wh[w]
							pfl "Cannot find widget #{w} inside list widget #{widget.name}"
						end
						widget= wh[w]
					end

					if $opts['debug-keys']
						pfl "Window #{@name}, widget #{focus}/#{widget.name}, key #{event}"
					end

					# Whatever the key press is, clear the window's status box,
					# if one exists.
					if wh['status']
						wh['status'].var_text= ''
					end
					# Now, if the widget focused has a tooltip assigned to it,
					# show it in the status box.
					if widget.tooltip
						wh['status'].var_text= ( '['+ widget.tooltip+ ']').truncate
					end

				else # (If we don't have anything focused or focused widget not found)
					if not focus
						pfl 'No particular widget focused, skipping keypress'
					else
						if widget
							pfl "Widget #{focus} focused, but not found in widget list, skipping keypress"
						end
					end
					## We only run another loop if the run mode (code) is 0 -- that's the
					## only mode intended to be ran in a loop. On all other codes, we
					## assume it was only intended to run once, so we break.
					#next if code== 0
					# (Actually we disable it here since we're doing it in the block just
					# below)
					#break
				end

				# Break if a single-loop was requested (code!= 0)
				# Next if the event has been handled by the widget and key is empty
				if code!= 0
					break
				elsif event.length== 0 or not( focus and widget)
					next
				end

				# If the currently focused widget has actions associated to it, and
				# there is 'hotkey_in' action somewhere in the menu, modify it to
				# represent the entry under cursor
				if hk= $app.screen.all_widgets_hash['hotkey_in']
					hk.widgets_hash['menu_hotkey_in_shortname'].var_text= widget.action.shortname
					hk.widgets_hash['menu_hotkey_in_shortname'].var_function= widget.action.function
					# XXX REDRAW MISSING?
				end

				# Unhandled ENTER on a widget will call its first action, if one is defined.
				# Otherwise we go into our usual keypress resolution.
				if event== 'ENTER'
					if a= widget.action
						if Symbol=== f= a.function
							a.send( f, :window => self, :widget => widget, :action => a, :function => f, :event => event)
						elsif Proc=== f= a.function
							f.yield( :window => self, :widget => widget, :action => a, :function => f, :event => event)
						end
					end
				else
					[ widget, *menus(), *widget.parent_tree()].each do |w|
						if a= w.hotkeys_hash[event]
							if Symbol=== f= a.function
								a.send( f, :window => self, :widget => widget, :action => a, :function => f, :event => event)
							elsif Proc=== f= a.function
								f.yield( :window => self, :widget => widget, :action => a, :function => f, :event => event)
							end
						end
					end
				end

				# NOTE: be aware that the code from IFs above will continue here.
				# Guard appropriately if you do not want that.

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
