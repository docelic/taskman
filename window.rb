# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# Or another way of thinking about it is a portion of the
# screen. (For example, the alpine theme consists of a 'screen'
# with header, body, status and menu windows)
#
# The main difference between Window and just using StflBase
# is that window implements main loop.

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
				# XXX rethink that? On a read only form one might still want to have
				# an action from the menu available for execution.
				if focus and widget

					# If a widget is list, set 'widget' to element in the list to be
					# more specific, don't just leave it at 'list'. (Or if finding a
					# listitem fails, then we remain at 'list')
					if widget.widget== 'list'

						# There was a bug in STFL up to 2014-12-14 (STFL <= 0.23) which
						# was causing pos_name to not work correctly. Discovered it and
						# sent our buddy Clifford a patch today.
						w= widget.var_pos_name_now
						unless wh[w]
							pfl _('Cannot find widget %s inside list widget %s')% [ w, widget.name]
						else
							widget= wh[w]
						end
					end

					if debug?( :keys)
						pfl _('Window %s, widget %s/%s, key %s')% [ @name, focus, widget.name, event]
					end

					# Whatever the key press is, clear the window's status box,
					# if one exists. (Or set it to the current item's tooltip, if any).
					if wh['status_label']
						wh['status_label'].var_text= ''
						# Now, if the widget focused has a tooltip assigned to it,
						# show it in the status box.
						if widget.tooltip
							wh['status_label'].var_text= ( _('[')+ widget.tooltip+ _(']')).truncate
						end
					end

				else # (If we don't have anything focused or focused widget not found)
					if not focus
						pfl _('No particular widget focused, skipping keypress')
					else
						if widget
							pfl _('Widget %s focused, but not found in widget list, skipping keypress')% [ focus]
						end
					end
				end

				# If the currently focused widget has actions associated to it, and
				# there is 'hotkey_in' action somewhere in the menu, modify it to
				# represent the entry under cursor
				if hk= wh['hotkey_in'] and widget.action
					hk.widgets_hash['menu_hotkey_in_shortname'].var_text= widget.action.shortname
					hk.function= widget.action.function
				end

				# Break if a single-loop was requested (code!= 0)
				# Next if the event has been handled by the widget and key is empty
				if code!= 0
					break
				elsif event.length== 0 or not( focus and widget)
					next
				end

				event.upcase!
				handled= false

				# Unhandled ENTER on a widget will call its first action, if one is defined.
				# Otherwise we go into our usual keypress resolution.
				if event== 'ENTER'
					if a= widget.action
						if Symbol=== f= a.function
							a.send( f, :window => self, :widget => widget, :action => a, :function => f, :event => event)
							handled= true
						elsif Proc=== f= a.function
							f.yield( :window => self, :widget => widget, :action => a, :function => f, :event => event)
							handled= true
						end
					end
				end

				unless handled
					[ widget, *menus(), *widget.parent_tree()].each do |w|
						if a= w.hotkeys_hash[event]
							if Symbol=== f= a.function
								a.send( f, :window => self, :widget => widget, :action => a, :function => f, :event => event)
								handled= true
							elsif Proc=== f= a.function
								f.yield( :window => self, :widget => widget, :action => a, :function => f, :event => event)
								handled= true
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
