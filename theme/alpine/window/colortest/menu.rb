module TASKMAN

	class Theme::Window::Colortest::Menu < Menu

		def initialize *arg
			super

			@widget= 'vbox'
			@page_size= 12
		end

		def to_stfl
			v= Vbox.new( :name => :menu, '.expand' => 0, '.height' => '2', :@style_normal => 'bg=red,fg=white')
			t= Table.new( '.expand' => 'h', '.height' => '1', :@style_normal => 'bg=blue,fg=white', '.display' => 1)

			pos= 0
			2.times do |i|
				6.times do
					t<< ( @widgets[@offset+ pos]|| Theme::MenuAction.new( :name => ''))
					pos+= 1
				end
				t<< Tablebr.new if i== 0
			end
			v<< t

			ret= v.to_stfl
			if debug?( :stfl)
				pfl "Widget #{@name} STFL: #{ret}"
			end
			ret
		end
	
	end

end
