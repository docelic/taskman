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
					w.var_text= ( '[ '+ arg+ ' ]').truncate2
				else
					w.var_text= ''
				end
			end
		end

		# Args: Question text, Proc
		def ask q, p
			if s= $app.screen['status']
				s['status_display'].var__display= 0
				s['status_prompt'].var__display= 1
				s['status_question'].var_text= q

				sa= s['status_answer']
				sa.var_text= ''
				sa.focus
				#sa.action.function= p

				# Remove all actions (if any) and set up for new prompt
				sa>> MenuAction
				sa<< MenuAction.new( p.merge( name: "#{@name}_handle_answer", instant: true))
				sa<< MenuAction.new( name: 'cancel_question') # Cancels on ESC

				# If instant action requested, disable in-widget keypress processing
				sa.var_process= if sa.instant then 0 else 1 end
			end
		end

		def init arg= {}
			if @slt
				self.status_label_text= @slt
			end
		end

	end

end
