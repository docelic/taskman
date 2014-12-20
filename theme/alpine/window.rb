# File implementing theme-specific window functions.

module TASKMAN

	class Theme::Window < Window

		def status_label_text= arg
			w= self['status_label']
			if w
				w.var_text= arg
			end
		end
		
	end

end
