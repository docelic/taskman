# File implementing theme-specific window functions.

module TASKMAN

	class Theme::Window < Window

		def status_label_text= arg
			w= self['status_label']
			if w
				if arg
					w.var_text= ( '[ '+ arg+ ' ]').truncate
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
				s['status_answer'].var_text= ''
				s['status_answer'].focus
				s['status_answer'].action.function= p
			end
		end
		
	end

end
