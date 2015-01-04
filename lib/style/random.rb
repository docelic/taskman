module TASKMAN
	class Style

		@@Def= [
			[ //, proc{{
					normal:   "fg=color#{Random.rand $opts['colors']},bg=color#{Random.rand $opts['colors']}",
					focus:    "fg=color#{Random.rand $opts['colors']},bg=color#{Random.rand $opts['colors']}",
					selected: "fg=color#{Random.rand $opts['colors']},bg=color#{Random.rand $opts['colors']}",
					end:      "fg=color#{Random.rand $opts['colors']},bg=color#{Random.rand $opts['colors']}",
				}}],
		]

	end
end
