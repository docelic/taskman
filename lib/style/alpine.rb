module TASKMAN
	class Style

		# This is a basic 2-color theme that is using standard colors of
		# your terminal, whatever they are. Also displays reverse colors
		# properly, due to using attr=reverse instead of specifying any
		# particular fg= or bg=.

		@@Def= [
			[ :'header',          normal: "attr=reverse", ],

			[ :'@list',           focus:  "attr=reverse", ],
			[ :'@button',         focus:  "attr=reverse", ],

			[ :'status_label',    normal: "attr=reverse", ],
			[ :'status_prompt',   normal: "attr=reverse", ],

			[ :'menu @hotkey',    normal: "attr=reverse", ],
			[ :'menu @hspace',    normal: "attr=reverse", ],
			[ :'menu @shortname', normal: "attr=reverse", ],
		]
	end
end
