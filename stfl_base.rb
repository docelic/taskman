# File implementing STFL base and extensions

require 'stfl'

module TASKMAN

	class StflBase < Object

		# All widgets and attributes will have a name automatically assigned if
		# unspecified, in the pattern of W_0, W_1, etc. I am considering removing
		# this and requiring all elements have a proper name. (This would be done
		# to make themes (different GUI layouts) and styles (different color
		# schemes) more convenient to write -- you would certainly not appreciate
		# going to style an element and discovering that its path/selector is
		# something like "main W_16 W_17 status status_label".
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

			# .all_widgets_hash() cache. This simple optimization in the function
			# results in ~5 times less computations of the function and about ~10
			# times performance increase on cumulative time spent in it.
			# The cache is cleared when list of child widgets is manipulated
			# through << and >>.
			@avhc= nil

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
			@variables['focus']||= 0

			# Now create accessor functions for all variables currently existing.
			# Get function (var_X) simply reads variable value from object.
			# Get now function (var_X_now) reads current value from STFL form.
			# Set function (var_X=) sets the variable as well as applies it to STFL.
			#
			# An additional feature of the set function is that it can be aware of
			# a different representation of an object in STFL. For example, in
			# theme 'alpine' the MenuAction object 'x' renders as 3 labels in STFL,
			# x_hotkey, x_hspace and x_shortname (see theme/alpine/menuaction.rb).
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

				if not respond_to? "var_#{fn}"

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
							$app.ui.set "#{name}_#{k}", arg.to_s
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

		def [] arg
			self.all_widgets_hash[arg]
		end
		# Focus widget itself
		def focus
			$app.ui.set_focus @name
		end
		# Focus child that was marked as to have default focus
		def focus_default
			@widgets.each do |w|
				if w.var_focus== 1
					$app.ui.set_focus w.name
					return
				else
					w.focus_default
				end
			end
		end

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
			@avhc= nil
			arg
		end
		def >> arg
			@widgets>> arg
			@widgets_hash.delete arg.name
			arg.parent= nil
			if MenuAction=== arg
				@hotkeys_hash>> arg.name
			end
			@avhc= nil
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
					$stderr.puts _('Menu action "%s" does not exist; skipping.')% [ a.to_s]
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
				pfl _("Widget %s STFL: %s")% [ @name, ret]
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

		# Not a real redraw
		#def redraw
		#	stfl_text= self.to_stfl
		#	$app.ui.modify @name.to_s, 'replace', stfl_text
		#end

		#$cnt= 0
		#$ctm= 0
		def all_widgets_hash hash= {} #, count= true
			# If cache is available, use it
			if @avhc then return @avhc end
			#$cnt+= 1
			#if count then s= Time.now.to_f end
			hash.merge!( { @name => self })
			@widgets.each do |c|
				hash.merge! c.all_widgets_hash #( {}, false)
			end
			#if count
			#	$ctm+= ( Time.now.to_f- s)
			#end
			@avhc= hash
		end

		# This function retrieves logical tree up to the top, including
		# parents that do not necessarily render in STFL (those that
		# have @widget= nil)
		def parent_tree tree= [ self]
			if @parent
				tree.push @parent
				@parent.parent_tree tree
			else
				return tree
			end
		end
		# And this is similar to the above, but only includes those
		# parents that do have some representation in STFL (i.e. their
		# @widget is not nil)
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
			# "...tree... <my classname>", then "...tree... <my STFL type>"
			# and then just for "....tree...".
			# So variation for e.g. a label of class Label_space
			# would be [ label_name, "@label_space", "@label", nil]
			variation= [ tree.pop]
			cnd= self.class_name.downcase
			variation.push "@#{cnd}" if cnd!= @widget
			if @widget then variation.push "@#{@widget}" end
			variation.push nil

			list= tree.dup # Start with a new tree
			( list.count+ 1).times do
				variation.each do |v|
					keys= [ list, v].flatten
					key= keys.join( ' ').strip
					break if key.length== 0
					if debug?( :style) then pfl _('Searching for style key %s')% [ key] end
					if s= $app.style[key]
						if debug then pfl _('Found style key %s')% [ key] end
						s.each do |k, v|
							if debug then pfl _('Applying style to %s: %s%s')% [ @name, k, v] end
							k= "var_style_#{k}=".to_sym
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
