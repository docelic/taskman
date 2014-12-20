module TASKMAN

	class Theme::Window::Index::Body < Window

		def initialize arg= {}
			super

			l= List.new( :name=> 'list')

			# So, we got $tasklist hash and just need to populate elements
			$tasklist.tasks.each do |id, i|
				n= id.to_s[0..10]
				s= "%s  %s" % [ n, i.subject]
				l<< ListItem.new( :name=> id.to_s, :text=> s)
			end

			self<< l
		end
	end
end
