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
			if not( @name= variables.delete( :name)) or @name.length< 1
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
			@variables['style_selected']||= ''
			@variables['autobind']||= 1
			@variables['modal']||= 0
			@variables['pos_name']||= ''
			@variables['pos']||= ''

			# Now create accessor functions for all variables currently existing.
			# Get function simply reads the variable value.
			# Set function sets the variable and applies it into STFL.
			# An additional feature of the set function is that it can be aware of
			# a different representation of an object in STFL. For example, the
			# MenuAction object 'x' would actually render as 3 labels in STFL,
			# x_hotkey, x_spacer and x_shortname.
			# Setting @stfl_names to those names allows the set function to know
			# what STFL widget names need to be set.
			@variables.each do |k, v|
				fn= k.gsub /\W/, '_'
				unless respond_to? k
					self.class.send( :define_method, "var_#{fn}".to_sym) {
						@variables[k]
					}
					self.class.send( :define_method, "var_#{fn}=".to_sym) { |arg|
						@variables[k]= arg
						names= if @stfl_names then @stfl_names else [ name] end
						names.each do |n|
							$app.ui.set "#{n}_#{k}", arg.to_s
						end
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
				if a== :tablebr
					self<< Tablebr.new
				elsif ma= Theme::MenuAction.new( :name => a.to_s)
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

			ret= "{#{@widget}[#{@name}] #{variables}#{widgets}}"
			if debug?( :stfl)
				pfl "Widget #{@name} STFL: #{ret}"
			end
			ret
		end

		def create
			stfl_text= to_stfl
			if $opts['debug-stfl']
				pfl stfl_text
			end
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

		def stfl_tree tree= [ self]
			if @parent and @parent.widget
				tree.push @parent
				@parent.stfl_tree tree
			elsif @parent
				@parent.stfl_tree tree
			else
				return tree
			end
		end

		def debug? type= nil
			opt= 'debug'+ ( type ? "-#{type}" : '')
			opt_widget= opt+ '-widget'
			if $opts[opt] or ( $opts[opt_widget] and $opts[opt_widget]== @name) then
				true
			else
				false
			end
		end

		# This function applies style to a widget by using a couple fallbacks.
		# Style is attempted to be applied for all three STFL style types.
		def apply_style type= [ 'normal', 'focus', 'selected']

			# No action if this object won't be rendering on its own
			return unless @widget

			debug= debug?( :style)

			s= {}

			# Produce the list of parent element names. This will be the basis of
			# our fallbacking and searching for styles and inheriting them from
			# parent widgets.
			tree= stfl_tree.reverse.map{ |w| w.name}

			# For each style type (normal, focus, selected)...
			type.each do |t|

				if debug
					pfl "Applying style #{t} to widget #{@name}"
				end

				# Make a copy of the list as we will be modifying it in each
				# loop and remember the initial size
				list= tree.dup

				# Assume that all widgets with a number at the end are just
				# "instances" of a basic widget, and want their basic style
				# applied. (E.g. widget name 'menu2' wants 'menu', not 'menu2)).
				list.map!{ |x| x.gsub /(?<!_)\d+$/, ''}

				pops= list.size

				# A "variation" is the thing allowing searching for a specific
				# widget name at the end, but then also searching for widget
				# type and/or removinfg the last element if not found.
				# (For example, if a final widget is called "x" and is of type
				# "hbox", then the variation fill first search for "... x", and
				# if not found, then for "... @hbox", and if still not found,
				# it will then search for just "..." without the final element
				# or type.)
				variation= [ list.pop, "@#{self.class_name.downcase}"]
				if @widget
					variation.push "@#{@widget}"
				end
				variation.push nil

				pops.times do |i|
					var= variation
					var.each do |v|

						# Produce a key by which we will look up a style
						# Not sure why list2= [ list] works without having to say *list?
						list2= [ list]
						if v then list2.push v end
						key= if list.size> 0 then list2.join( ' ') else v end

						# key will be nil when we are testing the variation only
						# (no list) and that variation is 'nil'. We skip those
						# cases, even though theoretically we could try not
						# skipping it, so that one could define one, global default
						# style using key '' (or nil?).
						next unless key

						if debug
							pfl "Searching for style key #{key}"
						end
						if s2= $app.style[key]
							if debug
								pfl "Found style key #{key}"
							end
							s2.each do |k, v|
								if debug
									pfl "Applying style to #{@name}: #{k}#{v}"
								end
								self.send k, v
							end
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
