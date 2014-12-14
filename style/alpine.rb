module TASKMAN
	class Style
		@@Def= {
			'head' => {
				:var_style_normal= => 'fg=black,bg=white',
			},

			'@list' => {
				:var_style_focus= => 'fg=black,bg=white',
			},

			'status' => {
				:var_style_normal= => 'fg=black,bg=white',
			},

			'menu @label_hotkey' => {
				:var_style_normal= => 'fg=black,bg=white',
			},
			#'menu @label_spacer' => {
			#	:var_style_normal= => 'fg=white,bg=black',
			#},
			#'menu @label_shortname' => {
			#	:var_style_normal= => 'fg=white,bg=black',
			#},
		}
	end
end
