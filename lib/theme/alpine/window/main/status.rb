require 'theme/alpine/window'

module TASKMAN

	class Theme::Window::Main::Status < Vbox

		def initialize arg= {}
			super arg.merge( '.expand'=> 'h')

			# Block dealing with displaying status information
			h1= Hbox.new(   name: "#{@name}_display",                               '.display'=> 1)
			#h1<< Hspace.new(name: "#{@name}_space1",  '.expand'=> '0', text: ' ')
			h1<< Hspace.new(name: "#{@name}_space2",                   text: '')
			h1<< Label.new( name: "#{@name}_label",   '.expand'=> '0', text: '')
			h1<< Hspace.new(name: "#{@name}_space3",                   text: '')

			# Block dealing with being able to ask questions and execute functions on answers
			h2= Hbox.new(   name: "#{@name}_prompt",                                '.display'=> 0)
			h2<< Label.new( name: "#{@name}_question",'.expand'=> '0', text: '')
			h2<< Hspace.new(name: "#{@name}_space4",  '.expand'=> '0', text: ' ')
			h2<< Input.new( name: "#{@name}_answer",  '.expand'=> 'h', text: '', can_focus: 0, modal: 1)

			self<< h1
			self<< h2
		end
	end
end
