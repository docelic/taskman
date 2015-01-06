module TASKMAN
	class Style

		# Defaults for 8-color terminals
		black  = 'black'
		yellow = 'yellow'
		magenta= 'magenta'
		cyan   = 'cyan'
		white  = 'white'

		# 256-color settings
		darkgray = 'color235'
		gray     = 'color240'
		orange   = 'color214'
		green    = 'color71'
		red      = 'color210'
		blue     = 'color111'

		if $opts['colors']== 16
			darkgray =  'color8'
			gray     =  'color7'
			orange   = 'color11'
			green    = 'color10'
			red      = 'color29'
			blue     = 'color14'
		elsif $opts['colors']== 8
			darkgray = 'color8'
			gray     = 'color7'
			orange   = 'color3'
			green    = 'color2'
			red      = 'color1'
			blue     = 'color4'
		end

		@@Def= [
			[ :header,            normal: "fg=#{white},bg=#{darkgray}", ],

			[ :'@vbox',           normal: "fg=#{white},bg=#{gray}", ], # Default fg/bg
			[ :'@vspace',         normal: "fg=#{white},bg=#{gray}", ], # - for spacers
			
			[ :'@textview',       normal: "fg=#{white},bg=#{gray}",    # - for widget
			                      end:    "fg=#{white},bg=#{gray}",
			],
			[ :'@textedit',       normal: "fg=#{white},bg=#{gray}",    # - ...
			                      end:    "fg=#{white},bg=#{gray}",
			],
			
			[ :'@input',          normal: "fg=#{white},bg=#{gray}", ],
			[ :'@label',          normal: "fg=#{white},bg=#{gray}", ],

			[ :'@checkbox',       normal:  "fg=#{white},bg=#{gray}",
			                      focus:   "fg=#{darkgray},bg=#{white}",
			],

			[ :'main @list',      normal:  "fg=#{white},bg=#{gray}",
			                      focus:   "fg=#{green},bg=#{darkgray}",
			                      selected:"fg=#{green},bg=#{darkgray}",
			],

			[ :'@list',           normal:  "fg=#{white},bg=#{gray}",
			                      focus:   "fg=#{green},bg=#{gray}",
			                      selected:"fg=#{green},bg=#{gray}",
			],

			[ :status_space,      normal: "fg=#{red},bg=#{darkgray}", ],
			[ :status_label,      normal: "fg=#{blue},bg=#{darkgray}", ],
			[ :status_prompt,     normal: "fg=#{red},bg=#{darkgray}", ],

			[ :menu,              normal: "fg=#{white},bg=#{darkgray}", ],
		]
	end
end
