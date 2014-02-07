class String
	## Extend String class to include uppercase-first function.
	#def ucfirst
	#	self.dup.ucfirst!
	#end

	#def ucfirst!
	#	self[0,1]= self[0,1].upcase
	#	self
	#end

	def lc() self.dup.downcase! end
	def lc!() self.downcase! end

	## Support to-boolean conversion
	#def to_bool
	#	return false if self == false || self =~ /^false$/i || self== ''
	#	return true  if self == true  || self =~ /^true$/i
	#	raise ArgumentError.new "Invalid value for Boolean: '#{self}'"
	#end

  def unindent
		#require "active_support/core_ext/string"
    #indent = scan(/^[ \t]*(?=\S)/).min.try(:size) || 0
    #gsub(/^[ \t]{#{indent}}/, '')
		gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, '')
  end

	def retab
		gsub(/^\t+/, ' ')
	end
end

# Extend Object class with some coding convenience
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

end

# Support >> notation for removing elements from array
class Array

	def >> arg
		delete arg
		self
	end

	def to_stfl
		self.map{ |i| i.to_stfl }.join ''
	end

end

class Symbol

	def to_str() to_s end

end

# Debugging aid - Print File, Line & Method, plus listed arguments inspected.
def pfl *arg
	print caller[0], '-> ', arg.inspect[1..-2]
	puts
end
