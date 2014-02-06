
module TASKMAN
	class StflBase < Object

		attr_reader :name
		attr_accessor :variables, :children

		def initialize variables= {}
			super()

			@children= []
			
			@widget= nil # Override, or default to module_name.downcase
			@name= variables.delete :name
			@variables= variables
		end

		def <<( arg) self.children<< arg end
		def >>( arg) self.children>> arg end

		def to_s
			'{'+
			( @widget ? @widget : self.class.to_s.gsub(/^.+::/, '').lc)+
			( @name ? "[#{@name}]" : '')+
			' '+
			@variables.map{|k, v| k.to_s+ ':'+ v}.join( ' ')+
			@children.map{|i| i.to_s}.join+
			'}'
		end
	end
end

