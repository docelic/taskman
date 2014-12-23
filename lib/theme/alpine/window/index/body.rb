module TASKMAN

	class Theme::Window::Index::Body < Window

		attr_reader :l, :fmt

		def initialize arg= {}
			super

			@fmt= " %-4s %-6s %s"
			h= @fmt % [ 'ID', ' DB ', 'SUBJECT']
			self<< Label.new( name: 'TH', text: h, :'.expand'=> 'h')

			@l= MVCList.new( name: 'list', autobind: 0)
			l<< MenuAction.new( name: 'pos_up')
			l<< MenuAction.new( name: 'pos_down')

			@l<< ListItem.new
			self<< @l
		end
	end
end
