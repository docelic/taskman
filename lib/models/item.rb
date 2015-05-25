# Representation of the task/item as class Item.
# Also, contains definition of class VirtualDate which represents
# our custom date object (search 'class VirtualDate' below)

module TASKMAN

	require 'date'
	require 'time'
	require 'active_record'

	class Item < ActiveRecord::Base

		has_many :categorizations, dependent: :destroy
		has_many :folders, through: :categorizations
		belongs_to :folder

		belongs_to :status

		attr_writer :folder_names
		after_save :assign_folders

		@@weekdays= Date::ABBR_DAYNAMES.map {|p| p.upcase}
		@@months= Date::ABBR_MONTHNAMES.dup
		@@months[0]= ''
		@@months.map! {|p| p.upcase}

		@@default_omit= []
		@@default_time= 43200

		# These will contain person's original input
		# These will contain value after parsing person's input
		#attr_accessor :_start, :_stop, :_due, :_omit, :_omit_shift, :_time_ssm, :_remind, :_omit_remind, :_subject, :_message
		#attr_accessor :id, :start, :stop, :due, :omit, :omit_shift, :remind, :omit_remind, :time_ssm
		#attr_accessor :subject, :message

		serialize :due, Array
		serialize :omit, Array
		serialize :remind, Array

		after_initialize do
			#self.subject||= ''
			##self.start= nil # definitely not before this Date
			##self.stop= nil # definitely not after this Date
			#self.due||= [] # list of VirtualDate this entry is due
			#self.omit||= [true] # list of VirtualDates to omit, 'true' for default list
			#self._omit||= '1'
			#self.omit_shift||= 0 # 0=> no shift, just drop, +X=> move X days after, -X=> move X days before
			#self._omit_shift||= '0'
			##self.time_ssm||= nil # activation time, in seconds since midnight 
			#self.remind||= [] # list of Dates or Times to activate the reminder on, or seconds relative to the the due date/time
			#self.omit_remind||= false # true=> also skip reminders on omitted days, false=> do not honor omits for reminders
			#self._omit_remind||= '0' # true=> also skip reminders on omitted days, false=> do not honor omits for reminders
			#self.message||= '' # Body of the task
		end 

#		def nid
#			# If e.g. we have TASKMAN::Item::Main with ID 4, this
#			# function will return [ :main, 4]
#			[ self.class.to_s.split( '::')[-1].downcase.to_sym, self.id]
#		end

		#def generate_id
		#	@id= ( Time.now.to_i.to_s+ Time.now.usec.to_s).to_i
		#end

		# Parser functions:
		# Each variable (start, stop, due, omit...) can be set directly
		# (e.g. e.due= [ ....], e.due<< ...,) or it can be initialized
		# with a convenient, text value.

		# To initialize from text value, call with .parse_*(), e.g.
		# e.parse_due( 'text'). The parse functions will append arrays
		# with new definitions whenever possible; to re-set a certain
		# field to only what you gave it, use e.parse_*=(), e.g. e.parse_due= ...

		# Supported syntax:
		# Anything accepted by Date.parse()
		def parse_start( l) self.start= Date.parse l end
		def parse_start=( l) self.parse_start l end
		# Supported syntax:
		# Anything accepted by Date.parse()
		def parse_stop( l) self.stop= Date.parse l end
		def parse_stop=( l) self.parse_stop l end
		# Supported syntax:
		# Anything accepted by parse_virtualdate() -- see below
		def parse_due( l) d= parse_virtualdate l; self.due<< d end
		def parse_due=( l) d= parse_virtualdate l; self.due= [ d] end
		# Supported syntax:
		# Anything accepted by parse_virtualdate() -- see below
		def parse_omit( l) d= parse_virtualdate l; self.omit<< d end
		def parse_omit=( l) d= parse_virtualdate l; self.omit= [ d] end
		# XXX
		def parse_omit_shift( l) self.parse_omit= l end
		def parse_omit_shift=( l) self.parse_omit_shift l end
		# Supported syntax:
		# HH[:MM[:SS]]
		# -HH[:MM[:SS]] (-3 == 21)
		def parse_time_ssm l  # (Sets time_ssm)
			minus= ( l.sub! /^-/, '') ? true : false
			a= l.split(":").map {|p| p.to_i}
			a[1]||= 0
			a[2]||= 0
			if minus
				@time= 24- a[0], 60- a[1], 60- a[2]
			else
				@time= a
			end
		end 
		def parse_time_ssm= ( l) self.parse_time_ssm l end
		# Initialize a reminder for an item.
		# Supported syntax:
		# 1) [+-]0.0UNIT[*[+-]0.0INTERVALxHOW_MANY]
		#    Example: -90M*10Mx3
		#    Start reminding 90 minutes before the event,
		#    and remind 3 times, once every 10 minutes
		# 2) Specific date and time, e.g. Jan 15, 2012 12:00
		# 3) Specific date parseable by Date.parse, limited to YYYY ...,
		#    YYYYMMDD, and day/mon abbrev ...
		def parse_remind l
			a= l.split( /,/).map{|x| x.strip}
			x= nil
			until a.empty?
				x= a.shift
				case x
				when /^([+-]?\d+(\.\d+)?)(\w)(\*([+-]?\d+(\.\d+)?)(\w)(x\d+))?$/ # Relative time, Amount+Unit
					f= parse_timeunit $3.upcase
					start= $1.to_f*f
					self.remind= add_to self.remind, start
					if $4 # repetition
						f= parse_timeunit $7.upcase
						n= $8[1..-1].to_i
						interval= $5.to_f* f
						(1..n).each do |i| 
							self.remind= add_to self.remind, start+ i*interval
						end 
					end 
					#pfl "REMIND IS #{@remind.join ', '}"
				when /(.+\s+)?(\d+:\d+(:\d+)?)(\s+.+)?/ 
					t= $2.split(":").map {|p| p.to_i}
					t[2]||= 0
					t= t[2] + t[1]*60 + t[0]*3600

					o, f= $1, $4

					if $1 or $4
						d= Date.parse "#{o} #{f}"
						t= d.to_time+ t
					else 
						raise ArgumentError, _('Missing date specification')
					end 
					self.remind= add_to self.remind, t
				when /^\d{4}\b/, /^\d{8}$/, /^[A-Za-z]{3}\b/
					#d= Date.parse( ([$&]+a.shift( 2)).join ' ')
					d= Date.parse x
					self.remind= add_to self.remind, d
				else 
					raise ArgumentError, _('Reminder parse error')
				end 
			end 
		end
		def parse_remind= ( l) self.parse_remind l end
		def parse_omit_remind( l) self.omit_remind= l end
		def parse_omit_remind=( l) self.parse_omit_remind l end

		def parse_subject( l) self.subject= l end
		def parse_subject=( l) self.parse_subject=  l end
		def parse_message( l) self.message= l end
		def parse_message=( l) self.parse_message=  l end
		def parse_status( l)
			s= nil
			if l and l.length> 0
				s= Status.find_or_create_by( name: l)
			end
			self.status= s
			self.save
		end
		def parse_status=( l) self.parse_status l end

		# Limited 'remind' compatibility

		# Remind compatibility. Probably reactivate once we get full
		# support that can directly read remind files.
		#def parse_remind_task str
		#	e= Event.new
		#	str.each_line do |l|
		#		l= l.strip
		#		case l
		#		when /^DUE /i then parse_due e, l[4..-1].strip
		#		when /^AT /i then parse_at e, l[3..-1].strip
		#		when /^OMIT /i then parse_omit e, l[5..-1].strip
		#		when /^REM /i then parse_remind e, l[4..-1].strip
		#		#when /^ATT /i then parse_attachment e, l[4..-1].strip
		#		else e.message<< l << "\n"
		#		end 
		#	end
		#	e
		#end 

		# Helper functions below

		def parse_timeunit str
			case str.upcase
			when 'S' then 1
			when 'M' then 60
			when 'H' then 3600
			when 'D' then 3600*24
			when 'W' then 3600*24*7
			else raise ArgumentError, _('Unknown time unit')
			end
		end 

		# Parse the date specification for DUE and OMIT
		# Supported syntax:
		# 1) +-DAYs. E.g. 3, -1 (3rd and last day of every month)
		# 2) YEARs. E.g. 2011
		# 3) Weekday names. E.g. MON, TUE
		# 4) Month names. E.g. JAN, FEB
		# 5) Day range. E.g. 12..22(2) (every 2 days from 12 to 22)
		# 6) Weekday range. E.g. MON..FRI
		# 7) Month range. E.g. JAN..JUN
		# 8) Year range. E.g. 2011..2014
		# 8) *+-aXb
		def parse_virtualdate l
			vd= VirtualDate.new
			a= l.split( /\s+/)
			x= nil
			until a.empty?
				y= a.shift
				x= y.upcase
				case x
				when /^[+-]?\d{1,2}$/ # day number
					i= x.to_i
					vd.day= add_to vd.day, i
				when /^\d{4}$/ # year number
					i= x.to_i
					vd.year= add_to vd.year, i
				when *@@weekdays
					vd.weekday= add_to vd.weekday, @@weekdays.index(x)
				when *@@months
					vd.month= add_to vd.month, @@months.index(x)
				when /^([+-]?\d{1,2}\.\.[+-]?\d{1,2})(\/\d+)?$/ # day range
					s= $1.split '..'
					s.map! {|p| p.to_i}
					if s[0]*s[1]<0 then 
						raise ArgumentError, _('Range with opposite enpoint signs')
					end
					r= if $2
						Range.new( *s).step( $2[1..-1].to_i)
					else
						Range.new( *s)
					end
					vd.day= add_to vd.day, r
				when /^[A-Z]{3}\.\.[A-Z]{3}$/ # weekday or month range
					s= x.split '..'
					if @@weekdays.index s[0] # weekday
						s.map!{ |x| @@weekdays.index x}
						vd.weekday= add_to vd.weekday, Range.new( *s)
					else # month
						s.map!{ |x| @@months.index x}
						vd.month= add_to vd.month, Range.new( *s)
					end 
				when /^(\d{3,4}\.\.\d{3,4})(\/\d+)?$/ # year range 
					s= $1.split '..'
					s.map! {|p| p.to_i}
					if s[0]*s[1]<0 then 
						raise ArgumentError, _('Range with opposite enpoint signs')
					end
					r= if $2
						Range.new( *s).step( $2[1..-1].to_i)
					else
						Range.new( *s)
					end
					vd.year= add_to vd.year, r
				when /^\*([+-]?\d+)(X\d+)?$/ # Repeat (n times)
					# Note: needs exact date or a finite date array
					per= $1.to_i
					n= $2 ? $2[1..-1].to_i : nil
					d= vd.day
					d= force_array d unless Enumerable=== d
					m= vd.month
					m= force_array m unless Enumerable=== m
					y= vd.year
					y= force_array y unless Enumerable=== y
					l= y.outer( m).outer( d, :flatten)
					l.map!{ |x| Date.new( *x).jd}
					if n
						l.map!{ |x| MethodCall.new :period?, per, x, x+n*per}
					else 
						l.map!{ |x| MethodCall.new :period?, per, x, false}
					end 
					l= l[0] if l.size== 1
					vd.julian= add_to vd.julian, l
					vd.day, vd.month, vd.year= nil
				when /^([<>])(\d+{3,4})$/	# year comparison
						# day comparisons not supported because of 
						# negative day numbers, use ranges instead
					op= $1.to_sym
					y= $2.to_i
					vd.year= add_to vd.year, MethodCall.new( op, y)
				#~ when /^\!(\S+)$/ # method call
				#when # = arbitrary expression evaluation 
				else 
					raise ArgumentError, _('VirtualDate parse error')
				end 
			end 
			vd
		end

		def ssm() self.time_ssm || @@default_time end

		def add_to list, item
			# if list is nothing yet, add just this item:
			if list.nil? then return item end
			# item must be turned into an array to append:
			item= Enumerable===item ? item.to_a : [item]
			# if list is just one item, force array and append: 
			list= Enumerable===list ? list.to_a : [list]
			list+item
		end  

		def time date= Date.today
			date.to_date.to_time+ ssm
		end 
		def time= time 
			self.time_ssm= case time
			when Array
				time[0]* 3600+ time[1]* 60+ time[2]
			when Time  
				time.hour* 3600+ time.min* 60+ time.sec
			else nil
			end
			
		end 
		def hour() (ssm/ 3600).to_i end
		def min() ((ssm% 3600)/ 60).to_i end
		def sec() ssm% 60 end
		
		def start= date
			self.start= date.to_date
		end 
		def stop= date
			self.stop= date.to_date
		end 


		# The main function for determining if the item is scheduled
		# for today or a certain date -- ask for e.on?( date)
		
		def on? date= Date.today
			# Todos are always on
			return true if Todo=== self

			d= date.to_date
			yes= due_on? d
			no=  omit_on? d
			if yes
				!no
			elsif no
				nil
			else # check for shifting due to @omit:
				if self.omit_shift== 0
					nil
				else 
					# -1=>search into the future, +1=>search into the past
					od= d- self.omit_shift
					while omit_on? od
						break (od-d).to_i if due_on? od
						od-= self.omit_shift
					end
				end
			end 
		end 

		def due_on? date
			return false if start and start> date
			return false if stop and stop< date
			check self.due, date
		end

		def omit_on? date
			check self.omit, date, @@default_omit
		end

		def check list, target, default_list=[]
			list= force_array list
			di= list.index true
			if di 
				list= list.dup
				list[ di..di]= *default_list if di
			end
			dayfold= target.days_in_month + 1
			list.reduce(false) do |m,e|
				break true if 
					match?( e.year, target.year) &&
					match?( e.month, target.month) && 
					match?( e.day, target.day, dayfold) && 
					match?( e.weekday, target.wday) && 
					match?( e.julian, target.jd)
			end
		end 

		def match? rule, value, fold= nil
			# fold is the starting value for negative numbers
			ret= case rule
				when nil then true
				when Numeric then rule==value
				when Symbol then value.send rule 
				when Proc, MethodCall then rule.call( value)
				when Enumerable then rule.include? value
				else false
			end
			if fold and !ret 
				# try once again, folding the test value around the specified point
				# careful with eg day<7 conditions, need to be translated to 1..7
				ret = match? rule, value-fold, nil
			end
			ret
		end  
				
		def remind_on? date= Date.today
			d= date.to_date
			# spearate reminders in absolute and relative
			abs= self.remind.select{ |x| Time===x || Date===x}
			rel= self.remind-abs
			# see if there is an absolute match
			abs.select!{ |x| d== x.to_date }
			abs.map!{ |x| x.respond_to? :hour ? x : x.to_time+ssm }
			# test for on? on each date-reminder 
			rel.map! do |x|
				# negative difference x means in advance
				# we are catching everything between 0 and 24 h that day: 
				# check and reverse check: 
				d00= d.to_time - 1 - x
				d24= (d+1).to_time - 1 - x
				t= nil
				if on? d00
					t= time( d00) + x
					t= nil unless d== t.to_date
				end
				if !t and on? d24
					t= time( d24) + x
					t= nil unless d== t.to_date
				end
				t
			end 
			rel.compact! 
			abs+rel
		end

		# Append to any existing values
		def parse_from hash
			hash.each_pair {|k, v|
				f= 'parse_' + k.to_s
				pfl f, v
				self.send( f, v)
			}
		end

		# Override any values with specific settings
		def parse_from! hash
			hash.each_pair {|k, v|
				f= 'parse_' + k.to_s + '='
				self.send( f, v)
			}
		end

		def self.new_from hash
			t= self.new
			t.parse_from hash
			t
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

		def folder_names
			@folder_names|| folders.map(&:name).join( ' ')
		end
		def parse_folder_names arg
			@folder_names= arg
		end

		def flag
			$session.flags[self.id.to_s]
		end
		def flag= arg
			$session.flags[self.id.to_s]= arg
		end

		private

		def assign_folders
			if @folder_names
				self.folders= @folder_names.split( /[\s,]+/).map do |n|
					Folder.find_or_create_by( name: n)
				end
			end
		end

	end


	# Representation of the virtual date
	class VirtualDate

		attr_accessor :year, :month, :day, :weekday, :julian
		attr_accessor :hour, :minute, :second, :relative

		def self.[]( date) 
			return date if date.kind_of? self 
			d= date.to_date
			r= self.new
			r.year= d.year
			r.month= d.month
			r.day= d.day
			r
		end

		def initialize 
			# matching rules: 
			# nil=>all, number=>only that one, symbol->send, block=>call to get T/F 
			# enumerable(incl. range): include?, MethodCall: call, true=> default
			@year= nil 
			@month= nil 
			@day= nil 
			@weekday= nil 
			@julian= nil # julian day number
		end 
	end 


	# Intended as a simplification for the parser, especially for the
	# comparison operators and period?, although everything could be
	# implemented using blocks as well. But blocks cannot be serialized
	# if we ever want to save the parsed state
	class MethodCall 	
		def initialize operator, *argument
			@operator= operator
			@argument= argument
		end 
		attr_reader :operator, :argument
		def call target
			target.send @operator, *@argument
		end 
		alias_method :==, :call # useful for include? on a list of MethodCalls
	end 

end
