#!/usr/bin/env ruby

require 'getoptlong'

$:.unshift File.dirname $0

require 'extensions'
require 'defaults'
require 'item'

require 'stfl_base'

require 'terminal'
require 'window'

require 'layout'
require 'layout/vbox'
require 'layout/hbox'
require 'layout/table'

require 'widget'
require 'widget/label'
require 'widget/input'
require 'widget/list'

require 'menu'
require 'menu/menuaction'

require 'theme'

$opts= TASKMAN::Defaults.new
opts= [
# # Important options
#	[ '--default-time',        '--dt',       GetoptLong::REQUIRED_ARGUMENT],
#	[ '--local' ,              '-l',         GetoptLong::NO_ARGUMENT],
#	[ '--help',                '-h',         GetoptLong::NO_ARGUMENT],
#	[ '--help-all',            '-H',         GetoptLong::NO_ARGUMENT],
#	# Misc / rarely used options
#	[ '--server' ,             '-s',         GetoptLong::NO_ARGUMENT],
#	[ '--client' ,             '-c',         GetoptLong::NO_ARGUMENT],
#	[ '--profile',             '-p',         GetoptLong::REQUIRED_ARGUMENT],
#	[ '--version',             '-V',         GetoptLong::NO_ARGUMENT],
#	[ '--debug',               '-d',         GetoptLong::NO_ARGUMENT],
#	[ '--verbose',             '-v',         GetoptLong::NO_ARGUMENT],
	[ '--garbage-collector',   '--gc',       GetoptLong::NO_ARGUMENT],
	[ '--stress-collector',    '--stress',   GetoptLong::NO_ARGUMENT],
#	[ '--state',               '--st',       GetoptLong::NO_ARGUMENT],
#	[ '--state-load',          '--sl',       GetoptLong::NO_ARGUMENT],
#	[ '--state-save',          '--ss',       GetoptLong::NO_ARGUMENT],
	[ '--window',              '-w',         GetoptLong::REQUIRED_ARGUMENT],
	[ '--theme',               '-t',         GetoptLong::REQUIRED_ARGUMENT],
]

args= GetoptLong.new *opts

begin
	args.each do |opt, arg|
		opt= opt.sub /^\-+/, ''           # Remove any '-'s in front of option name
		arg= true  if arg.length== 0      # Options accepting no argument mean 'true'
		arg= false if opt.sub! /^no-/, '' # If they start with "no-", they mean 'false'

#		# If set to false, the option value won't be saved to $opts
#		# after the parsing here is completed. Useful for "virtual"
#		# options that do not exist in $opts.
		propagate= true

#		# Only options that require special handling need to be listed explicitly,
#		# the rest get taken care of automatically.
		case opt
			when 'version'
				puts $opts['version']
				exit 0

#			when 'state'
#				$opts['state-load']= $opts['state-save']= arg
#				propagate= false
#
#			when 'local'
#				$opts['server']= true
#				$opts['client']= true
#				propagate= false
#
#			when 'server'
#				$opts['server']= true
#				$opts['client']= false
#				propagate= false
#
#			when 'help-all'
#				$opts['help-all']= true
#				usage
#				exit 0
#
#			when 'help'
#				usage
#				exit 0
		end

		$opts[opt]= arg if propagate
	end
rescue GetoptLong::InvalidOption
	exit 1
end

if $opts['debug']
	pfl $opts
end

#if $opts['data-dir'] and not File.directory? $opts['data-dir']
#	Dir.mkdir $opts['data-dir'], 0700
#end

GC.stress= $opts['stress-collector']
GC.disable unless $opts['garbage-collector']

module TASKMAN

	class Application < Object

		attr_reader :theme
		attr_accessor :screen, :ui

		def initialize *arg
			super()
		end

		def start
			exec
		end

		def exec
			@theme= Theme.new( :theme => $opts['theme'], :window => $opts['window'])

			@ui= @screen.create

			@screen.main_loop
		end

	end

end

$app= TASKMAN::Application.new ARGV

if __FILE__== $0
	$app.start
end
#if __FILE__ == $0
#	IRB.start(__FILE__)
#else
#	# check -e option
#	if /^-e$/ =~ $0
#		IRB.start(__FILE__)
#	else
#		IRB.setup(__FILE__)
#	end
#end

########################################################################
# Helper functions below

def usage
#	puts
#	puts 'Taskman'.center $opts['term_width']
#	puts "Ver. #{$opts['version']}".center $opts['term_width']
#	puts
#
#	head= 'OPTION                  SHORT       ARG?  DEFAULT  DESCRIPTION'
#	puts head
#
#	fmt= "%-22s  %-11s  %s    %-8s %s\n"
#	puts '-' * $opts['term_width']
#
#	$Opts[0...( $opts['help-all'] ? $Opts.size : $opt_break)].each {|o|
#		config_key= o[0][2..-1]
#		default= $default_opts[config_key]
#		#default= :nil if default== nil
#		arg= o[2] == GetoptLong::NO_ARGUMENT ? :N : :Y
#		printf fmt, o[0], o[1], arg, default, $description[config_key]
#	}
#
#	puts '-' * $opts['term_width']
#	puts
end
#def u() usage() end
