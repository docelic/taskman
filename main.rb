#!/usr/bin/env ruby
#
# Taskman - personal task scheduler program
#
# Davor Ocelic, docelic@spinlocksolutions.com
# http://techpubs.spinlocksolutions.com/taskman/
# http://www.spinlocksolutions.com/
#

require 'getoptlong'
require 'yaml'

begin
	require 'terminfo'
	#require 'readline'
	Signal.trap 'SIGWINCH', proc{
		#Readline.set_screen_size(TermInfo.screen_size[0], TermInfo.screen_size[1])
		$LINES, $COLUMNS= TermInfo.screen_size
	}
	$LINES, $COLUMNS= TermInfo.screen_size
rescue
	Signal.trap 'SIGWINCH', proc{
		$LINES, $COLUMNS= $ENV['COLUMNS'], $ENV['LINES']
	}
	$LINES, $COLUMNS= $ENV['COLUMNS'], $ENV['LINES']
end

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
require 'widget/textedit'
require 'widget/checkbox'
require 'widget/textview'

require 'menu'
require 'menuaction'

require 'theme'

require 'json'

$opts= TASKMAN::Defaults.new
$getopts= [
# # Important options
#	[ '--default-time',        '--dt',       GetoptLong::REQUIRED_ARGUMENT],
#	[ '--local' ,              '-l',         GetoptLong::NO_ARGUMENT],
	[ '--help',                '-h',         GetoptLong::NO_ARGUMENT],
#	[ '--help-all',            '-H',         GetoptLong::NO_ARGUMENT],
	[ '--version',             '-v',         GetoptLong::NO_ARGUMENT],
	[ '--garbage-collector',   '--gc',       GetoptLong::NO_ARGUMENT],
	[ '--stress-collector',    '--stress',   GetoptLong::NO_ARGUMENT],
#	[ '--state',               '--st',       GetoptLong::NO_ARGUMENT],
#	[ '--state-load',          '--sl',       GetoptLong::NO_ARGUMENT],
#	[ '--state-save',          '--ss',       GetoptLong::NO_ARGUMENT],
	[ '--window',              '-w',         GetoptLong::REQUIRED_ARGUMENT],
	[ '--theme',               '-t',         GetoptLong::REQUIRED_ARGUMENT],

	[ '--data-dir',            '--dd',       GetoptLong::REQUIRED_ARGUMENT],
	[ '--data-file',           '--df',       GetoptLong::REQUIRED_ARGUMENT],

	[ '--debug',               '-d',         GetoptLong::NO_ARGUMENT],
	[ '--debug-keys',         '--dk',        GetoptLong::NO_ARGUMENT],
	[ '--debug-opts',         '--do',        GetoptLong::NO_ARGUMENT],
	[ '--debug-style',        '--ds',        GetoptLong::NO_ARGUMENT],
	[ '--debug-style-widget', '--dsw',       GetoptLong::REQUIRED_ARGUMENT],
	[ '--debug-stfl',         '--dstfl',     GetoptLong::NO_ARGUMENT],
	[ '--debug-stfl-widget' , '--dstflw',    GetoptLong::REQUIRED_ARGUMENT],
]

def usage
	opts= TASKMAN::Defaults.new

	puts
	puts 'Taskman'.center
	puts "Ver. #{opts['version']}".center
	puts

	head= 'OPTION                  SHORT       ARG?  DEFAULT  DESCRIPTION'
	puts head

	fmt= "%-22s  %-11s  %s    %-8s %s\n"
	puts '-' * opts['term-width']

	$getopts.each {|o|
		config_key= o[0][2..-1]
		default= opts[config_key]
		#default= :nil if default== nil
		arg= o[2] == GetoptLong::NO_ARGUMENT ? :N : :Y
		printf fmt, o[0], o[1], arg, default, $description[config_key]
	}

	puts '-' * opts['term-width']
	puts
end

args= GetoptLong.new *$getopts

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
			when 'help'
				usage
				exit 0
		end

		$opts[opt]= arg if propagate
	end
rescue GetoptLong::InvalidOption
	exit 1
end

if $opts['debug-opts']
	pfl $opts
end

#if $opts['data-dir'] and not File.directory? $opts['data-dir']
#	Dir.mkdir $opts['data-dir'], 0700
#end

GC.stress= $opts['stress-collector']
GC.disable unless $opts['garbage-collector']

module TASKMAN

	class Application < Object

		attr_reader :theme, :style
		attr_accessor :screen, :ui

		def initialize *arg
			super()

			@style= {
				"head" => {
					:var_style_normal= => 'fg=black,bg=white',
				},
				#"body" => {
				#	:var_style_normal= => 'fg=white,bg=black',
				#},
				"menu @label_hotkey" => {
					:var_style_normal= => 'fg=black,bg=white',
				},
				"menu @label_spacer" => {
					:var_style_normal= => 'fg=white,bg=black',
				},
				"menu @label_shortname" => {
					:var_style_normal= => 'fg=white,bg=black',
				},

				"@list" => {
					:var_style_focus= => 'fg=black,bg=white',
				},

				"help" => {
					:var_style_normal= => 'fg=white,bg=red',
				},

				'status' => {
					:var_style_normal= => 'fg=black,bg=white',
				},
			}
		end

		def start
<<<<<<< HEAD

=======
>>>>>>> bf310c8... More work
			exec
		end

		def exec arg= {}
			# Tasks aspect
			tf= File.join $opts['data-dir'], $opts['data-file']
			$tasklist= if File.exists? tf
				YAML.load_file tf
			else
				{}
			end

			# GUI aspect
			wname= arg[:window] ? arg[:window] : $opts['window']
			@theme= Theme.new( :theme => $opts['theme'], :window => wname)

			@ui= @screen.create

			$app.screen.all_widgets_hash.each do |name, w|
				w.apply_style
			end

			@screen.main_loop -1
			@screen.main_loop
		end

	end

end

$app= TASKMAN::Application.new ARGV

if __FILE__== $0
	$app.start
end

