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
	def truncate diff= -1
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
		return false #if self== false or self=~ /f|n|0/i or self== ''
		#raise ArgumentError.new "Invalid value for Boolean: '#{self}'"
	end

end

class Fixnum

	def unit u= _('Task'), p= _('s')
		if self and self.to_s=~ /[^1]1$/
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
	
	def force_array x 
		x.kind_of?( Array) ? x : [x]
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
		opt= 'debug'+ ( type ? "-#{type}" : '')
		opt_widget= opt+ '-widget'
		if $opts[opt] or ( $opts[opt_widget] and @name and @name.match( $opts[opt_widget]))
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

class Hash
	def save
		self[:VERSION]= $opts['version']
		tf= File.join $opts['data-dir'], $opts['data-file']
		content= self.to_yaml
		File.write tf, content
	end
end

class Symbol
	def to_str() to_s end
end

module Enumerable 
	def outer( other, op= :pass)
		r= self.map{ |x| other.map{ |y| z=[x,y].send op }}
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
