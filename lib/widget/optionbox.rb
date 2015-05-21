module TASKMAN

	class Optionbox < Checkbox

		def initialize arg= {}
			super( { bind_toggle: ''}.merge arg)
			@widget= 'checkbox'
		end

		def toggle single= false
			val= super()

			if val== 1 and !single
				mygroup= self.variables['group']
				options= $app.screen.all_widgets_hash.select{ |k, v| mygroup== v.variables['group']}
				options.each do |k, v|
					v.toggle true if v.var_value_now== val and k!= @name
				end
			end

			val
		end
	end
end
