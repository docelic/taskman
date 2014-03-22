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
		attr_accessor :variables, :widgets, :widgets_hash, :hotkeys_hash, :widget
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

			# For actions associated to widgets
			@hotkeys_hash= {}
			
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
			@name= @name.to_s

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
			@variables['modal']||= 1

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
			if MenuAction=== arg
				@hotkeys_hash[arg.hotkey]= arg
			end
			arg
		end
		def >> arg
			@widgets>> arg
			@widgets_hash.delete arg.name
			arg.parent= nil
			if MenuAction=== arg
				@hotkeys_hash>> arg.name
			end
			arg
		end

		def add_action *arg
			arg.each do |a|
				if ma= Theme::MenuAction.new( :name => a.to_s)
					self<< ma
				else
					$stderr.puts "Menu action #{a.to_s} does not exist; skipping."
				end
			end
		end

		# Generic function translating an object into STFL representation.
		# If the object has @widget == nil, only the child elements are dumped,
		# with no toplevel container.
		def to_stfl
			widgets= @widgets.to_stfl

			# If this container widget should be transparent (if it's
			# not to be rendered as any visible widget), simply return
			# its children stfl-ed.
			return widgets unless @widget

			# Otherwise stfl itself, and return that + children stfl-ed
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

		# XXX Memoize if necessary
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
				tree.push @parent
				@parent.parent_tree tree
			else
				return tree
			end
		end

		def apply_style type= [ 'normal', 'focus', 'selected']
			s= {}
			tree= parent_tree.reverse
			widget_name= nil

			type.each do |t|
				if $opts['debug-style']
					pfl "Applying style #{t} to widget #{@name}"
				end

				list= tree.dup.map{ |w| w.name}
				pops= list.size
				variation= [ list.pop]
				if @widget
					variation.push "@#{@widget}"
				end

				pops.times do
					variation.each do |v|
						key= if list.size> 0 then [ list, v].join( ' ') else v end
						if $opts['debug-style']
							pfl "Searching for style key #{key}"
						end
						if s2= $app.style[key]
							if $opts['debug-style']
								pfl "Found style key #{key}"
							end
							s2.each {|k, v| self.send k, v}
							return s2
						end # if s2
					end # variation.each
					list.shift
				end # pops.times
			end # types.each
		end # def apply_style
	end # class
end # module

class Array

	# Ability to convert array to STFL, assuming all its elements
	# are STFL-based objects and respond to .to_stfl().
	def to_stfl() map{ |i| i.to_stfl}.join end

end
