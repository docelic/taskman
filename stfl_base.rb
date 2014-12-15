# File implementing STFL base and extensions

require 'stfl'

module TASKMAN

	class StflBase < Object

		# All widgets and attributes will have a name
		# automatically assigned if unspecified
		@@auto_widget_name= 'W'
		@@auto_widget_id= 0

		include Stfl

		attr_reader :name, :ui
		attr_accessor :variables, :widgets, :widgets_hash, :hotkeys_hash, :widget
		attr_accessor :parent, :tooltip

		# The variables are STFL-valid hash consisting of :var_name => value.
		# If :name is specified, it is deleted from variables and treated
		# differently. If name is unspecified, it is automatically assigned.
		# Variable names and values can be strings or symbols interchangeably
		# for both convenience and variables named with a dot (.width, .height
		# etc.).
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
			# is nil, the widget container is omitted and only widget's child
			# elements are dumped. E.g.:
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

			@parent= variables.delete( :parent)
			@tooltip= variables.delete( :tooltip)

			# STFl variables. May be empty
			@variables= {}
			variables.each do |k, v|
				@variables[k.to_s]= v
			end

			# STFL defaults. For variables listed here, the convenience accessors
			# named var_X/var_X_now/var_X= will be created automatically. E.g.
			# 'text' becomes var_text, .display becomes var__display.
			@variables['.display']||= 1
			@variables['style_normal']||= ''
			@variables['style_focus']||= ''
			@variables['style_selected']||= ''
			@variables['autobind']||= 1
			@variables['modal']||= 0
			@variables['pos_name']||= ''
			@variables['pos']||= 0
			@variables['offset']||= 0
			@variables['text']||= ''
			@variables['function']||= nil

			# Now create accessor functions for all variables currently existing.
			# Get function (var_X) simply reads variable value from object.
			# Get now function (var_X_now) reads current value from STFL form.
			# Set function (var_X=) sets the variable as well as applies it to STFL.
			#
			# An additional feature of the set function is that it can be aware of
			# a different representation of an object in STFL. For example, in
			# theme 'alpine' the MenuAction object 'x' renders as 3 labels in STFL,
			# x_hotkey, x_spacer and x_shortname (see theme/alpine/menuaction.rb).
			# Setting @stfl_names to those names allows the set function to know
			# what STFL widget names need to be set.
			#
			# Also, another additional feature of both get and set functions is that,
			# for textview/textedit in STFL >= 0.24 you access their text using
			# Stfl.text( form, 'widget_name') instead of
			# Stfl.get( form, 'widget_name_text').
			# Based on the object class name, these functions make those differences
			# transparent to the user.
			@variables.each do |k, v|
				fn= k.gsub /\W/, '_'
				unless respond_to? k

					# Reading from internal variable is straightforward
					self.class.send( :define_method, "var_#{fn}".to_sym) {
						@variables[k]
					}

					# Reading from STFL form needs .get/.text switch
					if(( TASKMAN::Textedit=== self or TASKMAN::Textview=== self) and fn== 'text')

						self.class.send( :define_method, "var_#{fn}_now".to_sym) {
							@variables[k]= $app.ui.send fn, @name
						}

					else
						self.class.send( :define_method, "var_#{fn}_now".to_sym) {
							@variables[k]= $app.ui.get "#{@name}_#{fn}"
						}
					end

					# And the same for writing to form
					if(( TASKMAN::Textedit=== self or TASKMAN::Textview=== self) and fn== 'text')

					 pfl "TODO Unimplemented"

					else
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
		end

		# Implement all pseudo-variables supported by STFL as read-only functions
		def _x_now()    $app.ui.get( "#{@name}:x"   ).to_i end
		def _y_now()    $app.ui.get( "#{@name}:y"   ).to_i end
		def _w_now()    $app.ui.get( "#{@name}:w"   ).to_i end
		def _h_now()    $app.ui.get( "#{@name}:h"   ).to_i end
		def _minw_now() $app.ui.get( "#{@name}:minw").to_i end
		def _minh_now() $app.ui.get( "#{@name}:minh").to_i end

		# Function to call after new(), to initialize anything that can't be
		# initialized during new(). By default, no work here. You would use
		# this if e.g. you want to run actions after the window is created.
		# For now, this has to be manual, but I'm thinking of a way to
		# support executing this automatically on X<< y
		def init *arg
		end

		# Shorthand for adding and removing child widgets from an object.
		# This is the preferred method; we generally do not use an explicit
		# Obj.widgets.push() or Obj.widgets.delete() anywhere as these
		# functions do more than that.
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
				elsif Theme::MenuAction=== a
					self<< a
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

			# Otherwise stfl itself, and return that + children
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
			if debug?( :stfl)
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

		def actions
			self.widgets.select{ |w| TASKMAN::MenuAction=== w}
		end
		# Return actions associated to a widget
		def action
			actions.first
		end

		# This function applies style to a widget by using a couple fallbacks.
		# Style is attempted to be applied for all three STFL style types.
		def apply_style

			# No action if this object won't ever be rendering / be visible.
			# (If you will want to show it conditionally, then don't set
			# @widget= nil but set .var__display= 0/1)
			return unless @widget

			debug= debug?( :style)

			s= {}

			# Parent tree:
			# Produce the list of parent element names. This will be the basis of
			# our fallbacking and searching for styles and inheriting them from
			# parent widgets.
			tree= stfl_tree.reverse.map{ |w| w.name} # From top to bottom (self)
			# Assume that all widgets with a number at the end are just
			# "instances" of a basic widget, and want their basic style
			# applied. (E.g. widget name 'menu2' wants 'menu', not 'menu2')).
			tree.map!{ |x| x.gsub /(?<=[a-zA-Z])\d+$/, ''}

			# Variations-- this is the final element in the search tree where
			# we search first for "...tree... <my name>", then for
			# "...tree... <my STFL type>" and then just for "....tree...".
			# So variation for e.g. a label would be [ label_name, "@label", nil]
			variation= [ tree.pop]
			if @widget then variation.push "@#{@widget}" end
			variation.push nil

			list= tree.dup # Start with a new tree
			( list.count+ 1).times do
				variation.each do |v|
					keys= [ list, v].flatten
					key= keys.join( ' ').strip
					break if key.length== 0
					if debug?( :style) then pfl "Searching for style key #{key}" end
					if s= $app.style[key]
						if debug then pfl "Found style key #{key}" end
						s.each do |k, v|
							if debug then pfl "Applying style to #{@name}: #{k}#{v}" end
							self.send k, v
						end
						return
					end # if s (if style found)
				end # variation.each
				list.shift
			end # list.count.times
		end # def apply_style
	end # class
end # module

class Array

	# Ability to convert array to STFL, assuming all its elements
	# are STFL-based objects and respond to .to_stfl().
	def to_stfl() map{ |i| i.to_stfl}.join end

end

				# A "variation" is the thing allowing searching for a specific
				# widget name at the end, but then also searching for widget
				# type and/or removing the last element if not found.
				# (For example, if a final/leaf widget in the tree is called "x"
				# and is of type "hbox", then the variation fill first search
				# for "... x", and if not found, then for "... @hbox", and if
				# still not found, it will then search for just "..." without
				# the final element or type.)
				# (Previously, this code was also searching for class name
				# lowercased, but apart from being basically equivalent to
				# searching for @widget, it was also working correctly in case
				# of widgets like TASKMAN::Label, but not in case of elements
				# such as Theme::Window::Main::Status (it was searching for
				# @status). So, we've commented the 'cnd' part for now and
				# rely on known-good @widget only.


