# File implementing theme-specific window functions.

module TASKMAN

	class Theme::Window < Window

		def initialize arg= {}
			super

			@slt= arg.delete :status_label_text
		end

		def status_label_text= arg
			w= self['status_label']
			if w
				if arg
					w.var_text= ( _('[ ')+ arg+ _(' ]')).truncate2
				else
					w.var_text= _( '')
				end
			end
		end

		# Args: Question text, Proc
		def ask q, a, o, *actions
			if s= $app.screen['status']
				s['status_display'].var__display= 0
				s['status_prompt'].var__display= 1
				s['status_question'].var_text= q

				sa= s['status_answer']
				sa.var_text= a
				sa.var_pos= a.length
				# TODO: Is there some error with input? Seems the size is uninitialized
				# if it is created empty and hidden?
				#pfl sa._x_now, sa._y_now, sa._h_now, sa._w_now
				sa.set_focus

				# Remove all actions (if any) and set up for new prompt
				sa>> MenuAction
				o.name= "#{@name}_handle_answer"
				sa<< o
				sa<< MenuAction.new( name: 'cancel_question') # Cancels on ESC

				# Push any extra actions onto the box, e.g. like pgup/pgdown etc.
				actions.each do |ea|
					sa<< ea
				end

				# If instant action requested, disable in-widget keypress processing
				sa.var_process= if o.instant then 0 else 1 end
			end
		end

		def init arg= {}
			if @slt
				self.status_label_text= @slt
			end
		end
	end
end
