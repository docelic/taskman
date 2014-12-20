module TASKMAN

	class Table < Layout

		def initialize *arg
			super

			@widget= 'table'
		end

	end

	class Tablebr < Layout

		def initialize *arg
			super

			@widget= 'tablebr'
		end

	end

end
