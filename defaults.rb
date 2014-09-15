# Option names and their default values. If these need to be overridable
# on the command line, add them to getopt in main.rb

module TASKMAN

	class Defaults < Object

		attr_reader :opts

		@@opts= {
		#	'state'              => true,
		#	'state-load'         => true,  # Load app state on startup?
		#	'state-save'         => true,  # Save app state on exit?
		#	'profile'            => nil,   # Settings profile name
			'data-dir'           => File.join( ENV['HOME'], '.taskman'),
			'data-file'          => 'tasks.yaml',

			'folder'             => true, # Default folder, true == all

			'debug'              => false,
			'debug-keys'         => false, # Debug key presses
			'debug-opts'         => false, # Debug options
			'debug-stfl'         => false, # Debug STFL text
			'debug-stfl-widget'  => nil, # Particular widget to debug STFL on
			'debug-style'        => false, # Debug STFL text
			'debug-style-widget' => nil, # Particular widget to debug style on

			'garbage-collector'  => true,  # Use Ruby garbage collector? (DEBUG OPTION)
			'stress-collector'   => false, # Stress Ruby garbage collector? (DEBUG OPTION)

			'version'	           => '0.12(8)',

			'term-width'         => ( $COLUMNS|| 80),
		#	'local'              => false,
		#	'default-time'       => false,
		#	'default-time'       => false,
		#	'default-time'       => false,
		#
		#	'server-host'        => 'localhost',
		#	'server-port'        => '4044',
		#	'autoconnect'        => 1,
		#
		#	'default_time'       => 12* 3600, # noon
		#	'verbose'            => true,
		#
		#	'server'             => true,
		#	'client'             => true,

			'window'             => 'main',
			'theme'              => 'alpine',
		}

		def initialize *arg
			super
			@opts= @@opts.dup
		end

		def []( arg) @opts[arg] end
		def []=( arg, val) @opts[arg]= val end

	end

end

$description= {
#  'state'                => 'Load/save program state on start/exit',
#  'state-load'           => 'Load program state on start',
#  'state-save'           => 'Save program state on exit',
#  'profile'              => 'Define settings profile to use',
  'garbage-collector'    => 'Run garbage collector?',
  'stress-collector'     => 'Stress garbage collector?',
  'help'                 => 'List program options',
  'version'              => 'Display program version',
  'window'               => 'Program window to open',
  'theme'                => 'GUI theme to use',
  'debug'                => 'Show general debug',
  'debug-keys'           => 'Show keypresses',
  'debug-opts'           => 'Show command line options',
  'debug-style'          => 'Show application of style',
  'debug-style-widget'   => 'Show style for named widget',
  'debug-stfl'           => 'Show generated STFL',
  'debug-stfl-widget'    => 'Show STFL for named widget',
  'data-dir'             => 'Data directory',
  'data-file'            => 'Tasklist file',

#  'default-time'         => 'Use 12:00 as default event time',
#  'verbose'              => 'Enable verbose mode',
#  'server'               => 'Run in server mode',
#  'client'               => 'Run in client mode',
#  'local'                => 'Run in local client+server mode',
#	'no-state'             => "Don't load/save program state on start/exit",
#	'no-state-load'        => "Don't load program state on start",
#	'no-state-save'        => "Don't save program state on exit",
#	'no-garbage-collector' => 'Set Ruby debug option',
#	'no-stress-collector'  => 'Set Ruby debug option',
#	'no-debug'             => 'Disable debug mode',
#	'no-verbose'           => 'Disable verbose mode',
}

