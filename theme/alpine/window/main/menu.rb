module TASKMAN

	class Theme::Window::Main::Menu < Menu

		def initialize *arg
			super

			@widget= :table
			@variables['.expand']= 'h'
			@variables['.height']= 1

			@page_size= 12
			@offset= 0
			@cols= 6

			#pos= 0
			#2.times do |i|
			#	6.times do
			#		self<< Theme::MenuAction.new( :name => ''))
			#		pos+= 1
			#	end
			#	self<< Tablebr.new if i== 0
			#end
		end
	
	end

end
