# File implementing STFL base and extensions

require 'stfl'

module TASKMAN

	class StflBase < Object

		# All widgets and attributes will have a name
		# automatically assigned if unspecified
		@@auto_widget_name= 'widget'
		@@auto_widget_id= 0

		include Stfl

		attr_reader :name, :ui
		attr_accessor :variables, :widgets, :widgets_hash
		attr_accessor :parent

		# The variables are STFL-valid hash consisting of :variable => value.
		# If :name is specified, it is deleted from variables and treated
		# differently. If name is unspecified, it is automatically assigned.
		# Variable names and values can be strings or symbols interchangeably.
		def initialize variables= {}
			super()

			# For widgets that support "paging"
			@offset= 0
			@page_size= nil

			# Child widgets container, array and by-name
			@widgets= []
			@widgets_hash= {}
			
			# Name of STFL widget that this object translates to. If @widget
			# is nil, the widget container is omitted and only widgets elements
			# are dumped. E.g.:
			# @widget= "vbox" -> to_stfl -> {vbox variables... {{child1}{child2}...}}
			# @widget= nil    -> to_stfl -> {child1}{child2}...
			@widget= nil

			# Name is always there for all objects. If unspecified,
			# automatic name is assigned
			unless @name= variables.delete( :name)
				@name= [ @@auto_widget_name, @@auto_widget_id].join '_'
				@@auto_widget_id+= 1
			end

			# STFl variables. May be empty
			@variables= {}
			variables.each do |k, v|
				@variables[k.to_s]= v
			end

			# STFL defaults
			@variables['.display']||= 1
			@variables['style_normal']||= ''
			@variables['style_focus']||= ''
			@variables['autobind']||= 1

			# Now create accessor functions for all variables currently existing
			@variables.each do |k, v|
				fn= k.gsub /\W/, '_'
				unless respond_to? k
					self.class.send( :define_method, "var_#{fn}".to_sym) {
						@variables[k]
					}
					self.class.send( :define_method, "var_#{fn}=".to_sym) { |arg|
						$app.ui.set "#{name}_#{k}", arg.to_s
						@variables[k]= arg
					}
				end
			end
		end

		# Shorthand for adding and removing child widgets from an object.
		# This is the preferred method; we generally do not use an explicit
		# Obj.widgets.push() or Obj.widgets.delete() anywhere.
		def << arg
			@widgets<< arg
			@widgets_hash[arg.name]= arg

			arg.parent= self

			arg
		end
		def >> arg
			@widgets>> arg
			@widgets_hash.delete arg.name
			arg.parent= nil
			arg
		end

		# Generic function translating an object into STFL representation.
		# If the object has @widget == nil, only the child elements are dumped,
		# with no toplevel container.
		def to_stfl
			pfl @offset, (@page_size ? @offset+ @page_size- 1 : -1)
			widgets= @widgets[@offset..(@page_size ? @offset+ @page_size- 1 : -1)].to_stfl

			return widgets unless @widget

			variables= @variables.map{ |k, v|
				variable_name= "#{@name}_#{k}"
				k.to_s+ "[#{Stfl.quote( variable_name)}]:"+ Stfl.quote( v.to_s)
			}.join ' '
			variables+= ' ' if variables.length> 0

			return "{#{@widget}[#{@name}] #{variables}#{widgets}}"
		end

		def create
			stfl_text= to_stfl
			Stfl.create stfl_text
		end

		def redraw
			stfl_text= self.to_stfl
			$app.ui.modify @name.to_s, 'replace', stfl_text
		end

		def all_widgets_hash hash= {}
			hash.merge!( { @name => self })
			@widgets.each do |c|
				hash.merge! c.all_widgets_hash
			end
			hash
		end

		def get arg
			@variables[arg]
		end

		def parent_tree tree= [ self]
			if @parent
				tree.unshift @parent
				@parent.parent_tree tree
			else
				return tree
			end
		end

		def apply_style type= [ 'normal', 'focus', 'selected']
			s= {}
			tree= parent_tree
			widget_name= nil
			type.each do |t|
				list= tree.map{ |x| x.name}
				while list.size> 0 or widget_name
					key= if list.size> 0 then list.join( ' ') else n= widget_name; widget_name= nil; n end
					if s2= $app.style[key]
						s2.each do |k, v|
							self.send k, v
						end
						#puts :FOUND, key
						#sleep 0.3
						return s
					end
					#puts :LOOKING_FOR, key
					#sleep 0.3
					
					# pop the last item from the list and continue searching forward.
					# However, if we just popped the second element of the list, treat
					# it as a generic widget name (regardless of window in which it is
					# found) and search for that later on, if no match is found.
					if list.size== 2
						widget_name= 'widget_'+ list[1]
					end
					list.pop
				end
			end

			# Now search for style definition for that widget name in
			# any window. We take it the widget name is second argument
			# in the list.
			s
		end

	end

end

class Array

	# Ability to convert array to STFL, assuming all its elements
	# are STFL-based objects and respond to .to_stfl().
	def to_stfl() map{ |i| i.to_stfl}.join end

end
