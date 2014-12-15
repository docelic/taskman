module TASKMAN
	class Style

		# Defaults for 8-color terminals
		black  = 'black'
		red    = 'red'
		green  = 'green'
		yellow = 'yellow'
		blue   = 'blue'
		magenta= 'magenta'
		cyan   = 'cyan'
		white  = 'white'

		# For higher color ones (16, 88, 256)
		if $opts['colors']>= 16
			white= 'color15'
		end

		@@Def= {
			'header' => {
				:normal => "fg=#{black},bg=#{white}",
			},

			'@list' => {
				:focus => "fg=#{black},bg=#{white}",
			},

			'status_label' => {
				:normal => "fg=#{black},bg=#{white}",
			},
			'status_prompt' => {
				:normal => "fg=#{black},bg=#{white}",
			},

			'menu @hotkey' => {
				:normal => "fg=#{black},bg=#{white}",
			},
			'menu @hspace' => {
				:normal => "fg=#{white},bg=#{black}",
			},
			'menu @shortname' => {
				:normal => "fg=#{white},bg=#{black}",
			},
		}
	end
end
