module TASKMAN
	class Style

		# Defaults for 8-color terminals
		white= 'white'

		# For higher color ones (16, 88, 256)
		if $opts['colors']>= 16
			white= 'color15'
		end

		@@Def= {
			'header' => {
				:var_style_normal= => "fg=black,bg=#{white}",
			},

			'@list' => {
				:var_style_focus= => "fg=black,bg=#{white}",
			},

			'status_label' => {
				:var_style_normal= => "fg=black,bg=#{white}",
			},
			'status_prompt' => {
				:var_style_normal= => "fg=black,bg=#{white}",
			},

			'menu @hotkey' => {
				:var_style_normal= => "fg=black,bg=#{white}",
			},
			'menu @hspace' => {
				:var_style_normal= => "fg=#{white},bg=black",
			},
			'menu @shortname' => {
				:var_style_normal= => "fg=#{white},bg=black",
			},
		}
	end
end
