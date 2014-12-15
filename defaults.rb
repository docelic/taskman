# Option names and their default values. If these need to be overridable
# on the command line, add them to getopt in main.rb

module TASKMAN

	class Defaults < Object

		attr_reader :opts

		@@opts= {
			'data-dir'           => File.join( ENV['HOME'], '.taskman'),
			'lib-dir'            => File.join( ENV['HOME'], '.taskman', 'lib'),
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

			'version'	           => '0.12(14)',

		#	'local'              => false,
		#	'default-time'       => false,

			'window'             => 'main',
			'theme'              => 'alpine',
			'style'              => 'alpine',

			'term-width'         => ( $COLUMNS|| 80),
			'colors'             => 256,
			'term'               => nil,
		}

		def initialize *arg
			super
			@opts= @@opts.dup
		end

		def []( arg) @opts[arg] end
		def []=( arg, val) @opts[arg]= val end

	end

end

# For printing descriptions as part of --help
$description= {
  'garbage-collector'    => 'Run garbage collector?',
  'stress-collector'     => 'Stress garbage collector?',
  'help'                 => 'List program options',
  'version'              => 'Display program version',
  'window'               => 'Program window to open',
  'theme'                => 'GUI layout scheme to use',
  'style'                => 'GUI color scheme to use',
  'colors'               => 'Number of colors to use (16, 256)',
  'term'                 => 'Value for TERM= emulator',
  'term-width'           => 'Term width to use',
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
}

