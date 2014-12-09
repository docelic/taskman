module TASKMAN

	class Theme::Window::Index::Body < Window

		def initialize *arg
			super()

			l= List.new

			# So, we got $tasklist hash and just need to populate elements
			$tasklist.each do |id, i|
				n= id.to_s[0..10]
				s= "%s  %s" % [ n, i.subject]
				l<< ListItem.new( :name => n, :text => s)
			end

			self<< l
		end

	end

end
