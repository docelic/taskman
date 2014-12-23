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
		attr_accessor :actions, :parent, :tooltip

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

			@actions= []

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
			@variables['pos']||= ''
			@variables['offset']||= 0
			@variables['text']||= ''
			@variables['function']||= nil
			@variables['focus']||= 0
			@variables['can_focus']||= 1

		end

		# Now create accessor functions for all above variables.
		# Get function (var_X) simply reads variable value from object.
		# Get now function (var_X_now) reads current value from STFL form.
		# Set function (var_X=) sets the variable as well as applies it to STFL.

		# For textview/textedit in STFL >= 0.24 you access their text using
		# Stfl.text( form, 'widget_name') instead of
		# Stfl.get( form, 'widget_name_text'). Such objects have their text()
		# function overriden in their corresponding classes.
		def var__display()       @variables['.display']       end
		def var_style_normal()   @variables['style_normal']   end
		def var_style_focus()    @variables['style_focus']    end
		def var_style_selected() @variables['style_selected'] end
		def var_autobind()       @variables['autobind']       end
		def var_modal()          @variables['modal']          end
		def var_pos_name()       @variables['pos_name']       end
		def var_pos()            @variables['pos']            end
		def var_offset()         @variables['offset']         end
		def var_text()           @variables['text']           end
		def var_function()       @variables['function']       end
		def var_focus()          @variables['focus']          end
		def var_can_focus()      @variables['can_focus']      end
		def var_value()          @variables['value']          end

		def var__display_now()       @variables['.display']=       ( $app.ui.get "#{@name}_.display"      ).to_i end
		def var_style_normal_now()   @variables['style_normal']=   ( $app.ui.get "#{@name}_style_normal"  )      end
		def var_style_focus_now()    @variables['style_focus']=    ( $app.ui.get "#{@name}_style_focus"   )      end
		def var_style_selected_now() @variables['style_selected']= ( $app.ui.get "#{@name}_style_selected")      end
		def var_autobind_now()       @variables['autobind']=       ( $app.ui.get "#{@name}_autobind"      ).to_i end
		def var_modal_now()          @variables['modal']=          ( $app.ui.get "#{@name}_modal"         ).to_i end
		def var_pos_name_now()       @variables['pos_name']=       ( $app.ui.get "#{@name}_pos_name"      )      end
		def var_pos_now()            @variables['pos']=            ( $app.ui.get "#{@name}_pos"           ).to_i end
		def var_offset_now()         @variables['offset']=         ( $app.ui.get "#{@name}_offset"        ).to_i end
		def var_text_now()           @variables['text']=           ( $app.ui.get "#{@name}_text"          )      end
		def var_function_now()       @variables['function']=       ( $app.ui.get "#{@name}_function"      )      end
		def var_focus_now()          @variables['focus']=          ( $app.ui.get "#{@name}_focus"         ).to_i end
		def var_can_focus_now()      @variables['can_focus']=      ( $app.ui.get "#{@name}_can_focus"     ).to_i end
		def var_value_now()          @variables['value']=          ( $app.ui.get "#{@name}_value"         ).to_i end

		def var__display=( arg)        $app.ui.set "#{@name}_.display"      , ( @variables['.display']= arg       ).to_s end
		def var_style_normal=( arg)    $app.ui.set "#{@name}_style_normal"  , ( @variables['style_normal']= arg   ).to_s end
		def var_style_focus=( arg)     $app.ui.set "#{@name}_style_focus"   , ( @variables['style_focus']= arg    ).to_s end
		def var_style_selected=( arg)  $app.ui.set "#{@name}_style_selected", ( @variables['style_selected']= arg ).to_s end
		def var_autobind=( arg)        $app.ui.set "#{@name}_autobind"      , ( @variables['autobind']= arg       ).to_s end
		def var_modal=( arg)           $app.ui.set "#{@name}_modal"         , ( @variables['modal']= arg          ).to_s end
		def var_pos_name=( arg)        $app.ui.set "#{@name}_pos_name"      , ( @variables['pos_name']= arg       ).to_s end
		def var_pos=( arg)             $app.ui.set "#{@name}_pos"           , ( @variables['pos']= arg            ).to_s end
		def var_offset=( arg)          $app.ui.set "#{@name}_offset"        , ( @variables['offset']= arg         ).to_s end
		def var_text=( arg)            $app.ui.set "#{@name}_text"          , ( @variables['text']= arg           ).to_s end
		def var_function=( arg)        $app.ui.set "#{@name}_function"      , ( @variables['function']= arg       ).to_s end
		def var_focus=( arg)           $app.ui.set "#{@name}_focus"         , ( @variables['focus']= arg          ).to_s end
		def var_can_focus=( arg)       $app.ui.set "#{@name}_can_focus"     , ( @variables['can_focus']= arg      ).to_s end
		def var_value=( arg)           $app.ui.set "#{@name}_value"         , ( @variables['value']= arg          ).to_s end

		# te/tv is in /tmp/TVIEW!!!

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
		def init arg= {}
		end

		# Clear all_widgets_hash() cache so that it is rebuilt on next access
		def clear_caches
			@avhc= nil
			@tsc= nil
			if p= self.parent
				p.clear_caches
			end
		end

		# Shorthand for adding and removing child widgets from an object.
		# This is the preferred method; we generally do not use an explicit
		# Obj.widgets.push() or Obj.widgets.delete() anywhere as these
		# functions do more than that.
		def << arg
			arg.parent= self
			if MenuAction== arg.class
				@actions<< arg
			else
				@widgets<< arg
				@avhc= nil
			end
			if MenuAction=== arg
				@hotkeys_hash[arg.hotkey]= arg
			end
			@widgets_hash[arg.name]= arg
			arg
		end
		# Widgets can be removed by object ref, by name, or by
		# class name in which case all widgets of that class will
		# be removed.
		# E.g.:
		# widget>> 'W_1' - removes widget name "W_1" from children
		# widget>> obj - removes obj from children
		# widget>> ListItem - removes all child ListItems
		def >> arg
			to_remove= []
			if String=== arg and self[arg]
				to_remove.push self[arg]
			elsif Class=== arg
				@widgets.each do |w|
					if arg=== w
						to_remove.push w
					end
				end
			else # It's an object
				to_remove.push arg
			end

			to_remove.each do |r|
				r.parent= nil
				if MenuAction== r.class
					@actions>> r
				else
					@widgets>> r
				end
				if MenuAction=== r
					@hotkeys_hash.delete r.name
				end
				@widgets_hash.delete r.name
			end
			@avhc= nil
			to_remove.count
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
			if @tsc then return @tsc end
			ret= @widgets.to_stfl

			# If this container widget should be transparent (if it's
			# not to be rendered as any visible widget), simply return
			# its children stfl-ed.
			if @widget
				# Otherwise stfl itself, and return that + children
				variables= @variables.map{ |k, v|
					variable_name= "#{@name}_#{k}"
					k.to_s+ "[#{Stfl.quote( variable_name)}]:"+ Stfl.quote( v.to_s)
				}.join ' '
				variables+= ' ' if variables.length> 0

				ret= "{#{@widget}[#{@name}] #{variables}#{ret}}"
			end
			if debug?( :stfl)
				pfl _("Widget %s STFL: %s")% [ @name, ret]
			end
			@tsc= ret
		end

		def create
			stfl_text= to_stfl
			if debug?( :stfl)
				pfl stfl_text
			end
			Stfl.create stfl_text
		end

		def replace
			stfl_text= self.to_stfl
			$app.ui.modify @name.to_s, 'replace', stfl_text
		end

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

		# Already has accessor
		#def actions
		#	self.actions
		#end
		# Return actions associated to a widget
		def action
			self.actions.first
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

			first_pass= true
			list= tree.dup # Start with a new tree
			( list.count+ 2).times do
				variation.each do |v|
					keys= [ list, v].flatten
					key= keys.join( ' ').strip
					break if key.length== 0
					if debug?( :style) then pfl _('Searching for style key %s')% [ key] end
					if s= $app.style[key]
						if debug then pfl _('Found style key %s')% [ key] end
						s.each do |k, v|
							if debug then pfl _('Applying style to %s: %s %s')% [ @name, k, v] end
							k= "var_style_#{k}=".to_sym
							self.send k, v
						end
						return
					end # if s (if style found)
				end # variation.each
				list.shift
				if first_pass and list.count== 0
					list.push tree[0]
					first_pass= false
				end
			end # list.count.times
		end # def apply_style
	end # class
end # module

class Array

	# Ability to convert array to STFL, assuming all its elements
	# are STFL-based objects and respond to .to_stfl().
	def to_stfl() map{ |i| i.to_stfl}.join end

end
