module TASKMAN

	class Theme::Window::Index::Body < Window

		def initialize arg= {}
			super

			hid= if arg[:id] then arg[:id].to_id_s else '' end

			l= List.new( :name=> 'list', :pos=> 1)

			fmt= "%-4s %-6s %s"

			h= fmt % [ 'ID', ' DB ', 'SUBJECT']
			l<< ListItem.new( :name=> 'TH', :text=> h, :can_focus=> 0)

			# So, we got $tasklist hash and just need to populate elements
			pos= 1
			$tasklist.tasks.each do |id, i|
				n= id.to_id_s
				pfl :COMPARE, n, hid
				s= fmt % [ id[1], id[0], i.subject]
				if n== hid
					l.var_pos= pos
				end
				l<< ListItem.new( :name=> n, :text=> s, :can_focus=> 1)
				pos+= 1
			end

			self<< l
		end
	end
end
