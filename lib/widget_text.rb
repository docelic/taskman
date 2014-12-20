module TASKMAN

	class WidgetText < Widget

		def initialize arg= {}
			super
			
			@widget=
				if arg[:widget] then
					arg[:widget]
				else
					wname= self.class.to_s
					wname.sub! /^.*::/, ''
					wname.downcase!
					wname
				end

			self.var_text= var_text
		end

		def var_text_now
			$app.ui.text @name
		end

		def var_text= arg
			formatted= arg.format_to_screen
			removed= self>> ListItem
			formatted.each do |l|
				self<< ListItem.new( :text=> l)
			end

			# Is it enough if we wrap this in removed> 0,
			# or has to be executed always?
			if removed> 0
				$app.ui.modify @name, 'replace', self.to_stfl
			end
		end

	end

end
