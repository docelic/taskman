module TASKMAN

	class Theme::Window::Create::Menu < Menu

		def initialize *arg
			super

			@widget= 'vbox'
			@page_size= 12
		end

		def to_stfl
			v= Vbox.new ( :name=> :menu, '.expand'=> 0,   '.height'=> '2')
			t= Table.new(                '.expand'=> 'h', '.height'=> '1', '.display'=> 1)

			pos= 0
			2.times do |i|
				6.times do
					t<< ( @widgets[@offset+ pos]|| Theme::MenuAction.new( :name=> ''))
					pos+= 1
				end
				t<< Tablebr.new if i== 0
			end
			v<< t

			v.to_stfl
		end
	
	end

end
