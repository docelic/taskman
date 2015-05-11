module TASKMAN

	class Textedit < WidgetText
		def initialize arg= {}
			super
			self<< MenuAction.new( name: 'insert_datetime')
		end
	end

end
