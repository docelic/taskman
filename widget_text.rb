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

			if self.var_text.length> 0
				self.var_text= var_text
			end
		end

		def var_text_now
			$app.ui.text @name
		end

		def var_text= arg
			removed= self>> ListItem

			# Always add an empty line at the end for editing
			# convenience.
			arg+= "\n "

			arg.split( /\n/).each do |l|
				l.gsub! /\t/, '  '
				if l.length <= $COLUMNS
					self<< ListItem.new( :text=> l)
				else
					words= l.split /\s+/
					buf= ''
					while words.count> 0
						if(( buf.length+ words[0].length)< $COLUMNS)
							buf+= ' '+ words.shift
						else
							self<< ListItem.new( :text=> buf.strip)
							buf= ''
						end
					end
					self<< ListItem.new( :text=> buf.strip)
				end
			end

			# Is it enough if we wrap this in removed> 0,
			# or has to be executed always?
			if removed> 0
				$app.ui.modify @name, 'replace', self.to_stfl
			end
		end

	end

end
