# File implementing various generic extensions to Ruby classes

class String

	def ucfirst
		self.dup.ucfirst!
	end

	def ucfirst!
		self[0,1]= self[0,1].upcase
		self
	end

	def to_date
		Date.parse( self).to_date
	end

  def unindent
		#require "active_support/core_ext/string"
    #indent = scan(/^[ \t]*(?=\S)/).min.try(:size) || 0
    #gsub(/^[ \t]{#{indent}}/, '')
		gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, '')
  end

	def retab
		gsub(/^\t+/, ' ')
	end

	# Convert string class name to class
	def to_class
		self.split( '::').inject( Object) {|o,c| o.const_get c}
	end

	def center columns= $opts['term-width']
		spacing= (( columns- self.length)/ 2).floor
		spacing > 0 ? ( sprintf "%#{spacing+ self.length}s", self): self
	end

	# Truncate not to exceed term width. Truncate the beginning instead
	# of the end of the string. Done that way primarily to support
	# descriptions in status line on Create window, where useful examples
	# are found at the end of the line.
	# Diff specifies how many columns should be left empty on the sides,
	# specified as a negative number.
	def truncate2 diff= -1
		available= $opts['term-width']+ diff
		needed= self.length
		offset= needed- available
		if offset<= 0
			self
		else
			'...'+ self[(offset+ 3)..-1]
		end
	end

	def to_bool
		return true if self== true or self=~ /t|y|1/i
		return false if self== false or self=~ /f|n|0/i #or self== ''
		nil
		#raise ArgumentError.new "Invalid value for Boolean: '#{self}'"
	end

	def char_to_bool
		return nil if self.length> 1
		return true if self== true or self=~ /t|y|1/i
		return false if self== false or self=~ /f|n|0/i #or self== ''
		nil
		#raise ArgumentError.new "Invalid value for Boolean: '#{self}'"
	end

	def format_to_screen
		# Always add an empty line at the end for editing
		# convenience.
		text= self+ if self.length> 0 then "\n " else ' ' end

		outbuf= []
		text.split( /\n/).each do |l|
			l.gsub! /\t/, '  '
			if l.length <= $COLUMNS
				outbuf<< l
			else
				words= l.split /\s+/
				buf= ''
				while words.count> 0
					if(( buf.length+ words[0].length)<= $COLUMNS)
						buf+= ' '+ words.shift

					else
						# If here, the existing buf+ line would not fit on screen.
						# However, we make a distinction between buf being empty and
						# having something already. If it already has something, we
						# send that out and start with a clean one.
						# If the if() goes into else() again after that, it means the
						# single line is too wide for the screen, so just forcibly
						# trim it, no other solution. (Generally only the divider
						# lines will suffer from this, which is completely fine.)
						if buf.length> 0
							outbuf<< buf.strip
						else
							words[0]= words[0][0..($COLUMNS- 1)]
						end
						buf= ''
					end
				end
				outbuf<< buf.strip
			end
		end

		outbuf
	end

	def unshift_to_argv
		if File.readable? self
			File.open( self){ |f|
				args= Shellwords.split f.read
				ARGV.unshift *args
			}
		end
	end

	def make_directory
		begin
			Dir.mkdir self, 0700
		rescue SystemCallError => e
			$stderr.puts e
		end
	end

	# From https://www.ruby-forum.com/topic/144310
	def superformat arg
		names = []
		target = gsub /(^|[^%])%(\w+):(\-?\d*)/ do
			space, name, len= $1, $2.to_sym, $3.to_i # don't forget to replace whatever wasn't %
			if arg.has_key? name
				arg[name]= sprintf "%#{len}s", arg[name].to_s.slice( 0..( len.abs- 1))
			end
			names<< name unless names.include? name
			#num= '' if num== 0
			"#{space}%#{names.rindex(name) + 1}$"
		end
		args = case arg
			when Hash
				names.map {|n| arg[n] or arg[n.to_sym]} # keys are often symbols
			when Array
				arg
			else
				[arg]
		end
		target% args
	end

end

class Fixnum

	def unit u= _('Task'), p= _('s')
		if self and self.to_s=~ /(^|[^1])1$/
			return u
		else
			return u+ p
		end
	end

end

class Object

	alias_method :self, :instance_exec
	alias_method :kind, :class
	alias_method :here, :binding
	alias_method :seti, :instance_variable_set
	alias_method :geti, :instance_variable_get

	def is_of? type
		self.class.ancestors.map( &:to_s).include? type
	end

	def runtime_reader( s) self.class.self { attr_reader s.to_sym} end
	def runtime_writer( s) self.class.self { attr_writer s.to_sym} end
	def runtime_accessor( s) self.class.self { attr_accessor s.to_sym} end

	def assert_class obj, *class_or_list
		classlist= force_array
		classlist.each do |c| 
			return if obj.kind_of? c
		end 
		raise TypeError, _("Argument %s not a kind of: %s")% [ c, classlist]
	end 
	
	def force_array
		self.kind_of?( Array) ? self : [self]
	end 
	
	def pass() self end 

	# Anything to string
	def a_to_s
		if Array=== self
			self.join ', '
		elsif Item=== self
			ret= ''
			ret+= _('Start')+       ': '+ @start.a_to_s+ "\n" if @start
			ret+= _('Stop')+        ': '+ @stop.a_to_s+ "\n" if @stop
			ret+= _('Due')+         ': '+ @due.a_to_s+ "\n" if @due.size> 0
			ret+= _('Omit')+        ': '+ @omit.a_to_s+ "\n" if @omit.size> 0
			ret+= _('Omit shift')+  ': '+ @omit_shift.a_to_s+ "\n" if @omit_shift
			ret+= _('Time')+        ': '+ @time_ssm.a_to_s+ "\n" if @time_ssm
			ret+= _('Remind')+      ': '+ @remind.a_to_s+ "\n" if @remind.size> 0
			ret+= _('Omit remind')+ ': '+ @omit_remind.a_to_s+ "\n" if @omit_remind
			ret+= _('Message')+     ': '+ @message.a_to_s+ "\n" if @message
			ret
		else
			self.to_s
		end

		def to_json
			hash = {}
			self.instance_variables.each do |var|
				hash[var] = self.instance_variable_get var
			end
			hash.to_json
		end
		def from_json! string
			JSON.load(string).each do |var, val|
				self.instance_variable_set var, val
			end
		end
	end

	def class_name
		self.class.to_s.gsub /.+::/, ''
	end

	# Simply call e.g. if debug?( :stfl) then... end
	# This will execute the if body if a person requested --debug-stfl on
	# the command line, or they requested --debug-stfl-widget NAME, where
	# your object has @name and @name== NAME
	def debug? type= nil
		opt_type= 'debug'+ ( type ? "-#{type}" : '')
		opt_widget= 'debug-widget'
		opt_type_widget= opt_type+ '-widget'

		if $opts[opt_type] or
		 ( $opts[opt_widget] and @name and @name.match( $opts[opt_widget])) or
		 ( $opts[opt_type_widget] and @name and @name.match( $opts[opt_type_widget]))
			true
		else
			false
		end
	end
end

class Array

	# Support >> notation for removing elements from array
	def >> arg
		delete arg
		self
	end

	def flatten1
		self.flatten 1
	end 

	def colfmt
		sizes= []
		out= ''

		if self[0] and sizes.size< self[0].size then
			self.each { |item|
				item.each_with_index { | item2, i|
					l= 0+ ( item2 ? item2.size : 0 )
					if not sizes[i] or sizes[i]< l then
						sizes[i]= l
					end
				}
			}
		end

		fmt= ''
		sizes.each_with_index { |size, i|
			fmt+= "%-#{size}s"+ (i< sizes.size-1 ? ' | ': "\n")
		}
		fmt.sub! ' \| $', ''

		self.each { |d|
			#d.map! { |s| "\"#{s}\"," }
			#d[-1].sub! ',$', '';
			#puts "GOT '#{fmt}' AND '#{d}'"
			d[2]||= ''
			out+= sprintf fmt, *d
		}

		out
	end

end

class FixedArray < Array
	def << arg
		super
		# Make sure window_history length does not exceed config setting
		while self.size> $opts['history-lines']
			self.shift
		end
	end
end

class Symbol
	def to_str() to_s end

	# Used to convert database name (like :main) into database class
	def to_item_class
		"TASKMAN::Item::#{self.to_s.ucfirst}".to_class
	end
end

module Enumerable 
	def outer( other, op= :pass)
		r= self.map{ |x| other.map{ |y| z=[x,y].send op}}
		r.flatten1
	end
end

class Numeric
	def period? period, from, to= nil
		if to
			if to> from
				return false if self> to or self< from
			else
				return false if self< to or self> from
			end
		elsif to== false
			return false if self< from
		end 
		(self- from) % period == 0
	end 
end 

class Date
	def days_in_month
		Date.new( self.year, self.month, -1).day
	end 
end

class Time
	def self.measure
		t= now
		x= yield
		[ now-t, x]
	end 
end 

# Debugging aid - Print File, Line & Method, plus listed arguments inspected.
def pfl *arg
	$stderr.print caller[0], '-> ', arg.inspect[1..-2], "\n"
end
