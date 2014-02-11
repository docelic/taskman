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
		attr_accessor :variables, :children, :children_hash

		# The variables are STFL-valid hash consisting of :variable => value.
		# If :name is specified, it is deleted from variables and treated
		# differently. If name is unspecified, it is automatically assigned.
		# Variable names and values can be strings or symbols interchangeably.
		def initialize variables= {}
			super()

			# Child widgets container, array and by-name
			@children= []
			@children_hash= {}
			
			# Name of STFL widget that this object translates to. If @widget
			# is nil, the widget container is omitted and only children elements
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
		end

		# Shorthand for adding and removing child widgets from an object.
		# This is the preferred method; we generally do not use an explicit
		# Obj.children.push() or Obj.children.delete() anywhere.
		def << arg
			@children<< arg
			@children_hash[arg.name]= arg
		end
		def >> arg
			@children>> arg
			@children_hash>> arg.name
		end

		# Generic function translating an object into STFL representation.
		# If the object has @widget == nil, only the child elements are dumped,
		# with no toplevel container.
		def to_stfl
			children= @children.to_stfl

			return children unless @widget

			variables= @variables.map{ |k, v|
				variable_name= "#{@name}_#{k}"
				k.to_s+ "[#{Stfl.quote( variable_name)}]:"+ Stfl.quote( v.to_s)
			}.join ' '
			variables+= ' ' if variables.length> 0

			return "{#{@widget}[#{@name}] #{variables}#{children}}"
		end

		def create
			stfl_text= to_stfl
			Stfl.create stfl_text
		end

		def redraw
			stfl_text= self.to_stfl
			$app.ui.modify @name.to_s, 'replace', stfl_text
		end

		def all_children_hash hash= {}
			hash.merge!( { @name => self })
			@children.each do |c|
				hash.merge! c.all_children_hash
			end
			hash
		end

		def get arg
			$app.screen.get [ @name, arg].join '_'
		end

	end

end

class Array

	# Ability to convert array to STFL, assuming all its elements
	# are STFL-based objects and respond to .to_stfl().
	def to_stfl() map{ |i| i.to_stfl}.join end

end
