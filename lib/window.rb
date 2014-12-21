# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# ($app.screen points to toplevel Ruby object (something that
# inherits from Window), and $app.ui is the corresponding
# STFL form object.)
#
# The main difference between Window and just using StflBase
# is that window implements main loop.

module TASKMAN

	class Window < StflBase

		attr_reader :title

		def initialize arg= {}
			super
			@title= arg.delete( :title)
		end

		def main_loop code= 0

			# Quick detector for cases where main_loop gets called recursively.
			if $main_loop #and code== 0
				pfl _('Already in main loop. Recursive call detected; exiting.')
				exit 1
			end
			$main_loop= true

			loop do
				event= $app.ui.run code
				focus= $app.ui.get_focus

				if event.length> 0 and event== $opts['exit-key']
					Stfl.reset
					puts 'Taskman finished.'
					exit 0
				end

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
					$app.screen.status_label_text=
						if widget.tooltip then
							widget.tooltip
						else
							nil
						end

				else # (If we don't have anything focused or focused widget not found)
					if not focus
						pfl _('No particular widget focused, skipping keypress')
					elsif widget
						pfl _('Widget %s focused, but not found in widget list, skipping keypress')% [ focus]
					else # Nor focus nor widget
						# This case happens e.g. on windows with not one focusable widget,
						# such as colortest
					end
				end

				# If the currently focused widget has actions associated to it, and
				# there is 'hotkey_in' action somewhere in the menu, modify it to
				# represent the entry under cursor
				if hk= wh['hotkey_in'] and widget.action and widget.var_modal== 0
					hk.widgets_hash['menu_hotkey_in_shortname'].var_text= widget.action.shortname
					hk.function= widget.action.function
				end

				# Break if a single-loop was requested (code!= 0)
				# Next if the event has been handled by the widget and key is empty
				if code!= 0
					break
				elsif event.length== 0 # or not( focus and widget)
					# (We comment the above 'or not...' because we want to process
					# keypresses even on windows with no focusable widgets.
					next
				end

				event.upcase!
				handled= false

				# Unhandled ENTER on a widget will call its first action, if one is defined.
				# Otherwise we go into our usual keypress resolution.
				if event== 'ENTER' and widget
					if a= widget.action
						a.run( :window => self, :widget => widget, :event => event)
						handled= true
					end
				end

				unless handled
					ary= []
					if widget
						ary.push widget, *menus(), *widget.parent_tree()
					else
						ary.push *menus()
					end
					ary.each do |w|
						next if w.nil?
						if a= w.hotkeys_hash[event]
							a.run( :window => self, :widget => widget, :event => event)
						end
					end
				end

				# Now, when everything was said and done, exit from this
				# loop if that was requested.
				if $stop_loop #and code== 0
					$stop_loop= false
					break
				end

				## Handle specific events in a generic way
				#if event== 'SLEFT'
				#	@show_next_key= true
				#elsif @show_next_key
				#	pfl focus, event
				#	@show_next_key= false
				#end
			end

			$main_loop= false
		end

		def menus
			@widgets.select{ |w| w.name=~ /^menu/}
		end
	end
end
