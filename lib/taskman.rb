#!/usr/bin/env ruby
#
# Taskman - personal task scheduler program
#
# Davor Ocelic, docelic@spinlocksolutions.com
# http://techpubs.spinlocksolutions.com/taskman/
# http://www.spinlocksolutions.com/
#

require 'gettext'
include GetText

module TASKMAN

	class Application
		attr_reader :theme, :style
		attr_accessor :screen, :ui

		def initialize *arg
			super()

			require 'getoptlong'
			require 'shellwords'

			$:.unshift File.join File.dirname( $0), '../lib'

			require 'extensions'
			require 'defaults'

			$opts= TASKMAN::Defaults.new

			rc= File.join $opts['data-dir'], 'taskmanrc'
			if File.readable? rc
				File.open( rc){ |f|
					args= Shellwords.split f.read
					ARGV.unshift *args
				}
			end

			$getopts= [
				# # Important options
				#	[ '--default-time',        '--dt',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--help',                '-h',         GetoptLong::NO_ARGUMENT],
				[ '--help-all',            '-H',         GetoptLong::NO_ARGUMENT],
				[ '--version',             '-v',         GetoptLong::NO_ARGUMENT],
				[ '--garbage-collector',   '--gc',       GetoptLong::NO_ARGUMENT],
				[ '--stress-collector',    '--stress',   GetoptLong::NO_ARGUMENT],
				[ '--window',              '-w',         GetoptLong::REQUIRED_ARGUMENT],
				[ '--theme',               '-t',         GetoptLong::REQUIRED_ARGUMENT],
				[ '--style',               '-s',         GetoptLong::REQUIRED_ARGUMENT],

				[ '--data-dir',            '--dd',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--data-file',           '--df',       GetoptLong::REQUIRED_ARGUMENT],

				[ '--exit-key',            '--ek',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--main-db',             '--db',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--echo-time',           '--ec',       GetoptLong::REQUIRED_ARGUMENT],

				[ '--focus-on-edit',       '--foe',      GetoptLong::REQUIRED_ARGUMENT],
				[ '--focus-on-create',     '--foc',      GetoptLong::REQUIRED_ARGUMENT],

				[ '--term',                '--te',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--term-width',          '--tw',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--colors',              '--co',       GetoptLong::REQUIRED_ARGUMENT],

				[ '--cache-stfl',          '--tsc',      GetoptLong::NO_ARGUMENT],
				[ '--cache-avh',           '--avhc',     GetoptLong::NO_ARGUMENT],
				# The --no versions just for getopt to not complain:
				[ '--no-cache-stfl',       '--no-tsc',   GetoptLong::NO_ARGUMENT],
				[ '--no-cache-avh',        '--no-avhc',  GetoptLong::NO_ARGUMENT],

				[ '--debug',               '-d',         GetoptLong::NO_ARGUMENT],
				[ '--debug-widget',        '--dw',       GetoptLong::REQUIRED_ARGUMENT],
				[ '--debug-keys',          '--dk',       GetoptLong::NO_ARGUMENT],
				[ '--debug-keys-widget',   '--dkw',      GetoptLong::REQUIRED_ARGUMENT],
				[ '--debug-opts',          '--do',       GetoptLong::NO_ARGUMENT],
				[ '--debug-style',         '--ds',       GetoptLong::NO_ARGUMENT],
				[ '--debug-style-widget',  '--dsw',      GetoptLong::REQUIRED_ARGUMENT],
				[ '--debug-stfl',          '--dstfl',    GetoptLong::NO_ARGUMENT],
				[ '--debug-stfl-widget' ,  '--dstflw',   GetoptLong::REQUIRED_ARGUMENT],
				[ '--debug-mvc',           '--dmvc',     GetoptLong::NO_ARGUMENT],
				[ '--debug-mvc-widget' ,   '--dmvcw',    GetoptLong::REQUIRED_ARGUMENT],
			]

			args= GetoptLong.new *$getopts

			begin
				args.each do |opt, arg|
					opt= opt.sub /^\-+/, ''           # Remove any '-'s in front of option name /
					arg= true  if arg.length== 0      # Options accepting no argument mean 'true'
					arg= false if opt.sub! /^no-/, '' # If they start with "no-", they mean 'false' /

					# If set to false, the option value won't be saved to $opts
					# after the parsing here is completed. Useful for "virtual"
					# options that do not exist in $opts.
					propagate= true

					# Only options that require special handling need to be listed explicitly,
					# the rest get taken care of automatically.
					case opt
						when 'version'
							puts $opts['version']
							exit 0

						when 'term-width'
							propagate= false
							ENV['COLUMNS']= arg
							$COLUMNS= $opts[opt]= arg.to_i

						when 'colors'
							propagate= false
							$opts[opt]= arg.to_i
							$opts['colors_set']= true

						when 'main-db'
							propagate= false
							$opts[opt]= arg.to_sym

						when 'echo-time'
							propagate= false
							$opts[opt]= arg.to_f

						when 'cache-stfl'
							propagate= false
							$opts['cache-stfl']= arg

						when 'cache-avh'
							propagate= false
							$opts['cache-avh']= arg
					end

					$opts[opt]= arg if propagate
				end
			rescue GetoptLong::InvalidOption
				exit 1
			end

			if $opts['debug-opts']
				pfl $opts
			end

			# Prefer local overrides of any modules
			$:.unshift $opts['lib-dir']

			require 'models/item'
			require 'models/category'
			require 'models/item_category'
			require 'models/session'

			require 'tasklist'

			require 'stfl_base'

			require 'window'

			require 'widget'
			require 'widget_text'
			require 'widget/label'
			require 'widget/input'
			require 'widget/list'
			require 'widget/textedit'
			require 'widget/checkbox'
			require 'widget/button'
			require 'widget/textview'
			require 'widget/hspace'
			require 'widget/vspace'

			require 'layout'
			require 'layout/vbox'
			require 'layout/hbox'
			require 'layout/table'

			require 'menu'
			require 'menuaction'

			require 'theme'
			require 'style'

			#if $opts['data-dir'] and not File.directory? $opts['data-dir']
			#	Dir.mkdir $opts['data-dir'], 0700
			#end

			GC.stress= $opts['stress-collector']
			GC.disable unless $opts['garbage-collector']

			ActiveRecord::Base.establish_connection(
				adapter:  'mysql2',
				host:     'localhost',
				username: 'taskman',
				password: 'taskman',
				database: 'taskman'
			)
		end

		def start_console
			# Make sure $LINES/$COLUMNS contain the current terminal size.
			# Prefer terminfo method if available, manually otherwise.
			if $opts['term-width']
				$COLUMNS= $opts['term-width']
			else
				ch= nil
				begin
					require 'terminfo'
					#require 'readline'
						#Readline.set_screen_size(TermInfo.screen_size[0], TermInfo.screen_size[1])
					ch= proc{
						$LINES, $COLUMNS= TermInfo.screen_size
						$opts['term-width']= $COLUMNS
					}
				rescue
					ch= proc{
						$LINES, $COLUMNS= ENV['COLUMNS'], ENV['LINES']
						$opts['term-width']= $COLUMNS
					}
				end
				ch.call
				Signal.trap 'SIGWINCH', ch
			end

			# Can require help now, when $COLUMNS' been set.
			require 'help'

			if $opts['term']
				ENV['TERM']= $opts['term']
				if not $opts['colors_set']
					if $opts['term'].match( /(\d+)/)
						case $1
							when 8, 16, 88, 256
								$opts['colors']= m
								$opts['colors_set']= true
						end
					end
					if not $opts['colors_set']
						c= `tput colors`.chomp.to_i
						if not c> 0
							c= 8
							$stderr.puts( _("Assuming '%s' with %d colors. Please invoke with --colors NUMBER if incorrect.") % [ $opts['term'], c])
							sleep 2
						end
						$opts['colors']= c
					end
				end
			elsif $opts['colors_set'] and $opts['colors']> 8
				ENV['TERM']= "screen-#{$opts['colors']}color"
			end

			if $opts['help']
				puts usage
				exit 0
			elsif $opts['help-all']
				# require help only if we need it at this step, and
				# with hope that --tw has already been passed and
				# $columns is initialized accordingly.
				require 'help'
				puts TASKMAN::Help.text.format_to_screen.join( "\n")
				exit 0
			end
		end

		def start
			$tasklist= Tasklist.new
			$session= Session.new

			# Two quick variables for controlling main loop. $main_loop
			# tells whether we already are in main loop (recursion
			# detector). $stop_loop instructs the main loop to exit.
			$main_loop= false
			$stop_loop= false

			# Initialize the window which is to be displayed first
			arg= exec( window: $opts['window'])

			loop do
				if debug?
					pfl "Entering main loop for #{@screen.class}"
				end

				@screen.main_loop -1
				if @screen.respond_to? :init
					@screen.init arg
				end
				@screen.main_loop

				if debug?
					pfl "Exiting previous main loop"
				end
			end
		end

		def exec arg= {}
			$session.update

			# GUI layout
			wname= arg[:window]
			arg[:window]= wname
			arg[:theme]= $opts['theme']
			@theme= Theme.new arg

			# GUI color scheme
			arg= { style: $opts['style']}
			@style= Style.new arg

			# @ui: lowlevel STFL object (e.g. Stfl.get() in the manual
			# is $app.ui.get() in Taskman).
			# @screen: toplevel element on screen and all its children;
			# these are the actual STFL-based Ruby objects etc.
			unless @ui= @screen.create
				$stderr.puts _('Error creating STFL form; exiting.')
				exit 1
			end

			$app.screen.all_widgets_hash.each do |name, w|
				w.apply_style
			end

			# After the window's been set up, inform the current main
			# loop that it should exit, and that the new window's
			# one needs to be started.
			$stop_loop= true

			arg
		end

		def usage
			opts= TASKMAN::Defaults.new
			out= []

			out<< ''
			out<< 'Taskman'.center
			out<< (_("Ver.")+ " #{opts['version']}").center
			out<< ''

			fmt= "%-22s%-12s%-6s%-9s%s"
			head= _('OPTION'), _('SHORT'), _('ARG?'), _('DEFAULT'), _('DESCRIPTION')
			out<< fmt% head

			fmt= "%-22s%-13s%-5s%-9s%s"
			out<< '-'* $opts['term-width']

			$getopts.each{ |o|
				config_key= o[0][2..-1]
				default= opts[config_key]
				#default= :nil if default== nil
				arg= o[2]== GetoptLong::NO_ARGUMENT ? :N : :Y
				out<< sprintf( fmt, o[0], o[1], arg, default, $description[config_key])
			}

			out<< '-'* $opts['term-width']
			out<< ''

			out.join "\n"
		end
	end
end

if __FILE__== $0
	trap( 'SIGINT') {}
	$app= TASKMAN::Application.new ARGV
	$app.start_console
	$app.start
end
