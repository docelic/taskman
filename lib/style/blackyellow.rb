module TASKMAN
	class Style

		# Defaults for 8-color terminals
		black  = 'black'
		white  = 'yellow'

		@@Def= [
			[ :'header',          normal: "fg=#{black},bg=#{white}", ],

			[ :'@list',           normal: "fg=#{white},bg=#{black}",
			                       focus: "fg=#{black},bg=#{white}", ],
			[ :'@button',         normal: "fg=#{white},bg=#{black}",
			                       focus: "fg=#{black},bg=#{white}", ],

			[ :'@textview',       normal: "fg=#{white},bg=#{black}", ],
			[ :'@textedit',       normal: "fg=#{white},bg=#{black}", ],
			[ :'@input',          normal: "fg=#{white},bg=#{black}", ],
			[ :'@checkbox',       normal: "fg=#{white},bg=#{black}", ],
			[ :'@label',          normal: "fg=#{white},bg=#{black}", ],

			[ :'status_label',    normal: "fg=#{black},bg=#{white}", ],
			[ :'status_prompt',   normal: "fg=#{black},bg=#{white}", ],

			[ :'menu @hotkey',    normal: "fg=#{black},bg=#{white}", ],
			[ :'menu @hspace',    normal: "fg=#{white},bg=#{black}", ],
			[ :'menu @shortname', normal: "fg=#{white},bg=#{black}", ],
		]
	end
end
