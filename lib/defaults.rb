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

			'debug'              => false, # General debug
			'debug-widget'       => nil,   # Debug all for particular widget
			'debug-keys'         => false, # Debug key presses
			'debug-keys-widget'  => nil, # Particular widget to debug key presses on
			'debug-opts'         => false, # Debug options
			'debug-stfl'         => false, # Debug STFL text
			'debug-stfl-widget'  => nil, # Particular widget to debug STFL on
			'debug-style'        => false, # Debug STFL text
			'debug-style-widget' => nil, # Particular widget to debug style on

			'garbage-collector'  => true,  # Use Ruby garbage collector? (DEBUG OPTION)
			'stress-collector'   => false, # Stress Ruby garbage collector? (DEBUG OPTION)

			# The version corresponds to date on which the changes/release
			# has been made, like this:
			# E.g. 0.12(21) === 2014/12/21
			# E.g. 1.10(14) === 2015/10/14
			'version'	           => '0.12(21)',

		#	'local'              => false,
		#	'default-time'       => false,

			'window'             => 'main',
			'theme'              => 'alpine',
			'style'              => 'alpine',

			'term-width'         => ( $COLUMNS|| 80),
			'colors'             => 8,
			'term'               => nil,

			'exit-key'           => 'F10',
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
  'garbage-collector'      => _('Run garbage collector?'),
  'stress-collector'       => _('Stress garbage collector?'),
  'help'                   => _('List program options'),
  'help-all'               => _('Display full help text'),
  'version'                => _('Display program version'),
  'window'                 => _('Program window to open'),
  'theme'                  => _('GUI layout scheme to use'),
  'style'                  => _('GUI color scheme to use'),
  'colors'                 => _('Nr. of colors (8, 16, 256)'),
  'term'                   => _('Value for TERM= emulator'),
  'term-width'             => _('Term width to use'),
  'debug'                  => _('Show general debug'),
  'debug-widget'           => _('Show all for named widget'),
  'debug-style'            => _('Show application of style'),
  'debug-style-widget'     => _('Show style for named widget'),
  'debug-stfl'             => _('Show generated STFL'),
  'debug-stfl-widget'      => _('Show STFL for named widget'),
  'debug-keys'             => _('Show keypresses'),
  'debug-keys-widget'      => _('Show keys on named widget'),
  'debug-opts'             => _('Show command line options'),
  'data-dir'               => _('Data directory'),
  'data-file'              => _('Tasklist file'),
  'exit-key'               => _('One-key exit from program'),

#  'default-time'         => 'Use 12:00 as default event time',
}

