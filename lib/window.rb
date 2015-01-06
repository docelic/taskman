# File implementing generic window functions.
# ('Window' in our terminology being what STFL calls 'form')
# ($app.screen points to toplevel Ruby object (something that
# inherits from Window), and $app.ui is the corresponding
# STFL form object.)
#
# The main difference between this Window and just using
# StflBase in classes is that Window contains implementation
# of main loop.

module TASKMAN

	class Window < StflBase

		attr_reader :title

		def initialize arg= {}
			super
			@title= arg.delete( :title)
		end

		def main_loop code= $opts['timeout']

			# Quick detector for cases where main_loop gets called recursively.
			if $main_loop and code>= 0
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

				# Here, we store in base_widget the original 'widget' we got from STFL
				# However, we also make a provision for our own custom implementation
				# of table to work in the same way, in which case base_widget is
				# derived a little differently. (We assume that RowSelector is
				# located within Row, which is located in a Table)
				if RowSelect=== widget
					base_widget= widget.parent ? widget.parent.parent : widget
				else
					base_widget= widget
				end

				# Searching for actions to execute (and doing other work)
				# only makes sense if some widget was focused
				# XXX rethink that? On a read only form one might still want to have
				# an action from the menu available for execution.
				if focus and widget

					# If a widget is list, set 'widget' to element in the list to be
					# more specific, don't just leave it at 'list'. (Or if finding a
					# listitem fails, then we remain at 'list')
					if List=== widget

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

#				# Now, handle the MVC part
#				if MVCList=== base_widget
#					base_widget.mvc
#				end

				# Break if a single-loop was requested (code< 0)
				# Next if the event has been handled by the widget and key is empty
				if code< 0
					break
				end

				event.upcase!

				# This if() works as follows:
				# It evaluates to true if widget is known, and the widget's action is
				# of instant type (triggers as soon as its widget is focused), or it
				# is not of 'instant' type but the user pressed ENTER on it.
				if widget and a= widget.action and( event== 'ENTER' ? !a.instant : a.instant)
					#event= a.run( window: self, widget: widget, base_widget: base_widget, event: event)
					event= a.run( window: self, widget: widget, base_widget: base_widget, action: a, function: a.function, event: event)
				end

				# Note that this if() will be true even if the STFL widget handles the
				# action and sets event to ''. It will be false only if we processed
				# the action and returned 'nil' to indicate that processing should
				# stop.
				if event
					ary= []
					if widget
						ary.push widget
						if widget.var_modal== 0
							ary.push *menus(), *widget.parent_tree()
						end
					else
						ary.push *menus()
					end
					ary.each do |w|
						next if w.nil?
						if a= w.hotkeys_hash[event]

							# Here we allow multiple actions to execute. Action which believes it has serviced
							# the event adequately should return "" to clear the event but allow other actions
							# to be tested, or nil to stop keypress handling.
							# Using this mechanism, since actions are tested in order of definition, it is
							# possible for one action to replace "event", thus triggering another action
							# after it. (E.g. a handler for "DOWN" could return "UP" to trigger some other
							# action (defined after it) that was bound to UP)
							event= a.run( window: self, widget: widget, base_widget: base_widget, action: a, function: a.function, event: event)
							if event== nil
								break
							end
						end
					end
				end

				# Now, when everything was said and done, exit from this
				# loop if that was requested.
				if $stop_loop #and code>= 0
					$stop_loop= false
					break
				end
			end

			$main_loop= false
		end

		def menus
			#@widgets.select{ |w| w.name=~ /^menu/}
			self.all_widgets_hash.values.select{ |w| w.name=~ /^menu/}
		end
	end
end
