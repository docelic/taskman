# Option names and their default values. If these need to be overridable
# on the command line, add them to getopt in main.rb

module TASKMAN

	class Defaults

		attr_reader :opts

		@@opts= {
			'data-dir'           => File.join( ENV['HOME'], '.taskman'),
			'lib-dir'            => File.join( ENV['HOME'], '.taskman', 'lib'),

			'folder'             => true, # Default tasks folder, true == ALL

			'debug'              => false, # General debug
			'debug-widget'       => nil,   # Debug all for particular widget
			'debug-keys'         => false, # Debug key presses
			'debug-keys-widget'  => nil, # Particular widget to debug key presses on
			'debug-opts'         => false, # Debug options
			'debug-stfl'         => false, # Debug STFL text
			'debug-stfl-widget'  => nil, # Particular widget to debug STFL on
			'debug-style'        => false, # Debug STFL text
			'debug-style-widget' => nil, # Particular widget to debug style on
			'debug-mvc'          => false, # Debug MVC accesses
			'debug-mvc-widget'   => nil, # Particular widget to debug MVC on
			'debug-sql'          => false, # Debug SQL accesses

			'garbage-collector'  => true,  # Use Ruby garbage collector? (DEBUG OPTION)
			'stress-collector'   => false, # Stress Ruby garbage collector? (DEBUG OPTION)

			'state-save'         => true, # Save state on exit?
			'state-load'         => true, # Load state on startup?

			# List of configured databases. Default is here just for convenience.
			'connection'         => {
				main:[adapter:'mysql2',host:'localhost',username:'taskman',password:'taskman',database:'taskman']
			},

			# Default priority multiplier. E.g. keypress 3 = priority 3 * 10 = 30
			'priority-granularity'=> 1,

			# The version corresponds to date on which the changes/release
			# has been made, like this:
			# E.g. 0.12(21) === 2014/12/21
			# E.g. 1.10(14) === 2015/10/14
			'version'	           => '1.05(31)',

		#	'local'              => false,
		#	'default-time'       => false,

			'window'             => nil,
			'theme'              => 'alpine',
			'style'              => 'alpine',

			'term-width'         => nil,
			'colors'             => 8,
			'term'               => nil,

			'cache-stfl'         => true,
			'cache-avh'          => true,

			'exit-key'           => 'F10',
			'main-db'            => 'main',

			'datetime-key'       => 'F6',
			'datetime-format'    => '%Y-%m-%d %H:%M:%S',

			'echo-time'          => 0.3,
			'timeout'            => 0,
			'tooltips'           => true,

			'history-lines'      => 10,

			'focus-on-edit'      => 'message',
			'focus-on-create'    => 'subject',
			'follow-jump'        => true,

			'index-fields'       => [ :pre, :flags, :id, :status, :subject],
			'index-titles'       => nil, # Will be auto-generated
			'index-delimiter'    => ' ',
			'content-pre'        => '',
			'format-pre'         => '%s',
			'format-flags'       => '%1s',
			'format-id'          => '%-4s',
			'format-status'      => '%-7s',
			'format-subject'     => '%s',
			'format-priority'    => '%3s ',
			'format-DEFAULT'     => '%10s',
			'title-pre'          => _(''),
			'title-flags'        => _(' '),
			'title-id'           => _('ID'),
			'title-status'       => _('STATUS'),
			'title-subject'      => _('SUBJECT'),
			'title-priority'     => _('PRI'),
			'title-DEFAULT'      => _(''),
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
  'help-install'           => _('Display install help text'),
  'help-all'               => _('Display full help text'),
  'version'                => _('Display program version'),
  'window'                 => _('Program window to open'),
  'theme'                  => _('GUI layout scheme to use'),
  'style'                  => _('GUI color scheme to use'),
  'colors'                 => _('Nr. of colors (8, 16, 256)'),
  'history-lines'          => _('Length of history buffers'),
  'term'                   => _('Value for TERM= emulator'),
  'term-width'             => _('Term width to use'),
  'state-save'             => _('Save state on exit?'),
  'state-load'             => _('Load state on startup?'),
  'debug'                  => _('Show general debug'),
  'debug-widget'           => _('Show all for named widget'),
  'debug-style'            => _('Show application of style'),
  'debug-style-widget'     => _('Show style for named widget'),
  'debug-stfl'             => _('Show generated STFL'),
  'debug-stfl-widget'      => _('Show STFL for named widget'),
  'debug-mvc'              => _('Show MVC logic'),
  'debug-mvc-widget'       => _('Show MVC on named widget'),
  'debug-keys'             => _('Show keypresses'),
  'debug-keys-widget'      => _('Show keys on named widget'),
  'debug-opts'             => _('Show command line options'),
  'debug-sql'              => _('Show SQL queries'),
  'data-dir'               => _('Data directory'),
  'data-file'              => _('Tasklist file'),
  'exit-key'               => _('One-key exit from program'),
  'datetime-key'           => _('One-key to insert date/time'),
  'datetime-format'        => _('Strftime format of date/time'),
  'main-db'                => _('Name of main/own database'),
  'echo-time'              => _('Duration of msg visibility'),
  'tooltips'               => _('Show automatic tooltips'),
  'timeout'                => _('Force main loop every X ms'),
  'cache-stfl'             => _('Enable/disable STFL cache'),
  'cache-avh'              => _('- internal hierarchy cache'),
  'focus-on-edit'          => _('Field to focus on Edit Task'),
  'focus-on-create'        => _('Field to focus on Create -'),
	'follow-jump'            => _('In lists, follow current task'),
	'priority-granularity'   => _('Priority = 0-9 * this_value'),
	'index-fields'           => _('Columns to show in Task Index'),
	'index-titles'           => _('Titles of columns shown'),
	'index-delimiter'        => _('Delimiter between fields'),
	'connection'             => _('Define MySQL connections'),
	'content-pre'            => _('Content for spacer element'),
	'format-pre'             => _('Sprintf format for pre'),
	'format-flags'           => _('Sprintf format for flags'),
	'format-id'              => _('Sprintf format for id'),
	'format-status'          => _('Sprintf format for status'),
	'format-subject'         => _('Sprintf format for subject'),
	'format-priority'        => _('Sprintf format for priority'),
	'format-DEFAULT'         => _('Sprintf format (DEFAULT)'),
	'title-pre'              => _('Column title for pre'),
	'title-flags'            => _('Column title for flags'),
	'title-id'               => _('Column title for id'),
	'title-status'           => _('Column title for status'),
	'title-subject'          => _('Column title for subject'),
	'title-priority'         => _('Column title for priority'),
	'title-DEFAULT'          => _('Column title (DEFAULT)'),

#  'default-time'         => 'Use 12:00 as default event time',
}
