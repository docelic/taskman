module TASKMAN
  require 'time'
  class Help

		def self.text() @@text end

		opts= TASKMAN::Defaults.new

		@@text= "\n"+
'GENERAL INFORMATION ON THE TASKMAN TASK SCHEDULER'.center + "\n\n"+
"Version #{opts['version']}".center+ "\n"+
"#{Time.now.utc.iso8601}".center+ "\n\n"+
"Copyright 2014-2015 Spinlock Solutions".center+ "\n"+
"http://techpubs.spinlocksolutions.com/taskman/".center+ "\n\n"+
%q^

Table of Contents:

1. Basic Information
2. Task Creation & Features
3. Scheduling / Reminder Syntax
4. Database Sources
5. Developer Overview
6. Command Line Options

^+ '-'* ( $COLUMNS- 1)+ %q^

1. BASIC INFORMATION

Taskman allows creation of task/TODO/event lists and offers extensive tracking, scheduling and reminding features.

Taskman is primarily a personal scheduler program, but shared calendars and event lists are planned, as well as plugins for other calendar and task tracking apps. Please report your wishes in that regard to help prioritize work.

Taskman's scheduling features have been inspired by a program called Remind, although Taskman is more powerful and elaborate.

Taskman's default user interface has been inspired by the venerable mailer program Pine (or free Alpine), although Taskman supports completely different/customizable layouts ("themes") and color schemes ("styles").

Taskman's displayed key bindings and shortcuts have largely been adjusted to match those of Pine. However, Taskman has also been influenced by standard/generic Unix shortcuts, bash, vim and mutt. (E.g. Ctrl+L for clear screen, / and ? for searching, : for Go-to-Line, N and P for Find Next/Find Prev, e for View/Edit).

Taskman's data store is powered by ActiveRecord. Tasks can be viewed and/or edited depending on your privileges in the corresponding databases.

^+ '-'* ( $COLUMNS- 1)+ %q^

2. TASK CREATION & FEATURES

Taskman's functionality revolves around creating tasks, defining their scheduling (recurrence) and reminding options, setting their statuses and tracking progress / time spent.

Tasks can be created by starting Taskman and navigating to "CREATE TASK" in the main menu, or pressing "C" (case insensitive). From the command line, task creation can be opened directly by passing option "-w create" to the program (and the same for all other windows; --window main|create|index|list|help|colortest).

The most important window is the Create/Edit window, and creating or editing a task supports defining the following options/attributes:

1. Subject: task title / summary

2. Category: list of categories the task belongs to. (A task can belong to multiple categories and it has a separate/individual Priority in each.)

3. Status: status of the task. (A task can only have one status (or no status at all).)

4. Start: absolute start date for the task. Before the start date, task will be considered inactive and Taskman will never show it as due or remind you about it. By default, there is no start date (the task is always considered active if it matches other criteria).

5. End: absolute end date for the task. After the end date, task will be considered inactive and Taskman will never show it as due or remind you about it. By default, there is no end date (the task is always considered active if it matches other criteria).

6. Time: time of day when the task is due. By default, it is set to 12:00:00.

7. Due dates: days on which the task is due. A task can be due on multiple days, defined as specific dates (e.g. Jan 1, 2015) as well as various repetition rules (e.g. every Monday, every two days between 12th and 22nd of a month, last working day of a week, etc.).

8. Omit dates: days on which the task should not be due, even if it would otherwise be due on those days. This field accounts for days being holidays, non-working days (weekends) or any other exceptions to the rule. It supports the same syntax as Due dates.

9. Omit shift: behavior in case a task would be due on an omitted day. Task can either be ignored (not triggered) or Taskman can reschedule it, either to the first earlier or first later non-omitted day.

10. Remind: days and times when Taskman should remind you about the upcoming task or event. It can remind on a specific day or relative to the due date. For example, you might desire Taskman to start reminding you 90 minutes before the event and remind a total of 3 times with 10 minutes in between.

11. Omit remind: behavior in case that a reminder is due on an omitted day. Reminder can be ignored (not triggered), or Taskman can remind anyway.

^+ '-'* ( $COLUMNS- 1)+ %q^

3. SUPPORTED SYNTAX

Here's the syntax supported by the above-described fields:

SUBJECT
Syntax: free-form text
Example: Test 123
Example: Meeting with X

CATEGORY
Syntax: none or more of configured/available task categories
Example: Work
Example: Private

STATUS
Syntax: none or one of configured/available task statuses
Example: OPEN
Example: DONE

START
Syntax: simple date specification
Example: 2014-01-30
Example: 20140130
Example: 30th Dec 2014

END
Syntax: simple date specification
Example: 2015-01-30
Example: 20150130
Example: 30th Dec 2015

TIME
Syntax: HH:MM | HH:MM:SS | -HH:MM | -HH:MM:SS
Example: 12:30
Example: 12:30:15
Example: -2:00 (two hours before midnight)
Example: -2:00:15

DUE DATES
Syntax: DAY_NR | -DAY_NR | YEAR | DAY_NAME | MON_NAME | DAY_NR..DAY_NR(STEP)
Syntax: DAY_NAME..DAY_NAME(STEP) | MON_NAME..MON_NAME(STEP)
Syntax: YEAR_NR..YEAR_NR(STEP) | *+-aXb | >YEAR_NR
Example: 3 (every 3rd of month)
Example: -1 (every last day of month)
Example: 2012, 2013 (every day in 2012 and 2013)
Example: MON, TUE (every Monday and Tuesday)
Example: JAN, FEB (every day in January and February)
Example: 12..22(2) (every 2 days from 12th to 22nd of month)
Example: MON..FRI (every workday)
Example: JAN..DEC(2) (every day of every second month)
Example: 2012..2014 (every day in 2012, 2013 and 2014)
Example: *+-aXb
Example: >2014 (every day in 2014 and onward)

OMIT DATES
Syntax: same as above
Examples: same as above

OMIT SHIFT
Syntax: 1 | 0 | -1
Example: 1 (reschedule to the first earlier non-omitted day)
Example: 0 (ignore the task / event, do not reschedule it)
Example: -1 (reschedule to the first later non-omitted day)

REMIND
Syntax: -90M*10Mx3 | MON_NAME DAY_NR YEAR HH:MM | YYYY-MM-DD
Example: -90M*10Mx3 (remind 90 minutes earlier, 3 times every 10 minutes)
Example: Jan 1 2014 12:00 (specific date and time)
Example: 2014-01-01 (specific date)

OMIT REMIND
Syntax: 0 | 1
Example: 0 (remind regardless of being an omitted day)
Example: 1 (ignore the reminder, do not trigger it)

^+ '-'* ( $COLUMNS- 1)+ %q^

4. DATABASE SOURCES

Taskman supports defining multiple databases, with one database always being primary. The idea behind this feature is that users would have their own, primary database. However, they could connect to other users' databases to see the tasks that have been shared with them.

If multiple databases are configured, the tasks do not show all at once. Instead, the view shows tasks from the database currently selected as primary. To see tasks from another database, in the "Main", "Folder List" or "Index" windows press Backspace to see the list of available, configured databases.

Creating new or editing existing tasks in other databases works as well, as long as the user has sufficient privileges in the corresponding databases. Tasks that a person clones can be cloned into either the current database, or into the user's primary one.

^+ '-'* ( $COLUMNS- 1)+ %q^

5. DEVELOPER OVERVIEW

Taskman execution starts in main.rb. It instantiates the TASKMAN::Application class in global variable $app to represent the application (similar to how Qt would do it), defines and parses command line options, loads Ruby and local modules, prints --help if it was requested, initializes the console, and starts the main loop.

The following global variables are available at all times:

1. $LINES (int), $COLUMNS (int) - terminal height and width
2. $opts (hash) - current program options (program defaults modified by config file and/or the command line)
3. $getopts (array) - getopt definitions (probably not relevant if not doing something specifically related to parsing command line options)
4. $app (object) - instance of TASKMAN::Application. Most useful accessors are $app.ui (STFL object) and $app.screen (Ruby object of toplevel element visible on screen, and from there you can access all children regardless of position in hierarchy via $app.screen[WIDGET_NAME])
5. $app.usage() - function that returns a formatted string of command line options (output of taskman -h)
6. $session - store for current/running parameters, e.g. the current folder a person wants to be in.

Main loop:
----------

Once main.rb sets everything up, it calls  $app.start() which creates the requested window and runs the main loop. Window is created by invoking $app.exec(), the same function that is used to switch from one window to another.

The main loop that start() runs is based around STFL's main loop implementation + a couple conveniences that you therefore don't need to be implementing yourself. Here's their listing:

1) Our main_loop runs in the context of a window, instead of globally, so the current window object is always readily available as 'self'. Similarly, all your functions that Taskman core will call will be called with a rich set of arguments, allowing for easy and comfortable implementation of various handlers, menu actions, etc. (all defined in TASKMAN::MenuAction (menuaction.rb)).

2) The main loop automatically creates pointer to the current/focused widget object (instead of you having to look for it manually), and it automatically displays the focused widget's tooltip in the "status" line, if the focused widget has a tooltip and the status widget exists on the current form.  An example of this is e.g. seeing syntax help in the status line while you are pressing Up/Down over the various task option inputs in the "Create Task" window.

3) If the widget under focus has an action associated with it, the main loop automatically adjusts the "hotkey" entry in the window menu, if "hotkey_in" action exists on the current form.  (If there are multiple actions associated, it takes the first one which is suitable, i.e. the first one which is not explicitly set not to be a default action with "default: false".) An example of this is e.g. when you are in the program's main window and are pressing Up/Down to move between the options (Create Task, Task Index, etc.). The Hotkey field in the menu at the bottom changes automatically.

4) If ENTER is pressed on a widget, the main loop will automatically execute its first default action, if one is associated with it.  An example of this is e.g. when you are in the program's main window and you press ENTER on 'CREATE TASK' in the list. It executes the associated action which opens the Create Task window.

5) Keypresses other than ENTER which are not handled by the widget go through a search list: we check whether the key pressed matches any of the hotkeys associated with the widget itself, then the window's menus, then all the widget's parents up to the top of the tree.  An example of this is e.g. when you are in the CREATE TASK window, and press Ctrl+X to create the task. The Ctrl+X is a hotkey matching one of the entries in the window's menu, and it gets executed. After it has processed the key, each keypress handler is expected to return the (possibly new/different) event key, or nil to stop further processing. (If the return value from an action is not nil, the original event will be replaced with the return value and searching for matching actions will continue down the list.)

Now, a chapter on STFL:
-----------------------

In its essence, STFL is a textual GUI definition language and it is not object-oriented. In Taskman, a complete wrapper has been written so that you would only manipulate Ruby objects, and the STFL part would automagically take care of itself.

For example, to create a window named "Hello" and display a label in it, you would simply call:

module TASKMAN
  class Theme::Window::Hello < Theme::Window

		def initialize *arg
			super
			@widget= 'vbox'
			self<< Label.new( name: 'lbl1', text: 'Hello, World!')
		end

	end
end

If you saved that to a file theme/alpine/window/hello.rb and ran 'ruby main.rb -w hello', it would work! (In fact, that file exists in the Taskman distribution for demonstration purposes; simply run taskman with '-w hello' to see it.)

Insights to pick up from that example:

1) Every class wishing to use STFL needs to inherit from one of STFL-derived classes (in this case Theme::Window), which in turn all inherit from our base class named StflBase, which ultimately uses Stfl.rb that comes from the STFL distribution.

2) When a window (or any StflBase-derived object) needs to be converted to STFL text, it happens via calling .to_stfl() on it. That function is defined in our stfl_base.rb and it outputs a desired element in STFL with the corresponding name and options, and it also STFL-izes all its children elements and returns the complete STFL. If the object has no name (because it is e.g. just a supporting element that you will never want to access or be interested in, such as a supporting HBox or VBox) then its name will be autogenerated, in the pattern of W_0, W_1, W_2, etc. (To be technically correct, auto-assigning a name happens during calling .new() on a StflBase-derived class if the name parameter is not provided among the options, and not during a later call to .to_stfl()).

3) The toplevel STFL element seen in the text generated by .to_stfl() is coming from instance variable @widget, and all typical widget types (such as label, checkbox etc., found in the widget/ subdirectory) have their values for @widget appropriately set.  But you could manipulate @widget manually to override the element type in STFL, or set @widget = nil to just STFL-ize the children without creating a STFL representation of the current object.

4) In the "Hello, World!" example we can also see the syntax "self<< Label.new(...)".  The "<<" is an operator defined in stfl_base.rb, and it is used to add a widget (Label in our case) as a child of parent ('self' in our case).  It does this by adding a widget to parent's variables @widgets and @widgets_hash, and also handles hotkeys if the child being added is a MenuAction instead of a simple widget. In any case, please always use this 'parent<< child' syntax instead of manually manipulating the described variables.

5) Final thing to know re. the basic STFL is that it is flat, there is no hierarchy and all elements can be accessed by their name directly from toplevel API.

In Taskman, $app.ui always points to this basic STFL form currently shown, and it allows one to e.g.  read form value of e.g. an input field by simply calling $app.ui.get 'OBJ_NAME_text'. This is basic, standard STFL usage as one would learn from reading STFL docs.

However, our Ruby wrapper is much more elaborate. First of all, it is aware of the hierarchy. Each widget has a .parent() pointing to its parent, and @widgets/@widgets_hash accessors pointing to its children. When << is used, it forcibly sets child widget's parent to the widget it was added to. (Similar to how Qt does it.) It is also what allows one to call widget.to_stfl() and get the complete structure of Ruby objects (the parent and all children) converted to STFL text ready for displaying on the screen. If you will be doing any trickery besides plain using << and >> to add and remove children on StflBase-derived objects, consider calling OBJ.clear_caches() once you are done. It will rebuild the cached output of .all_widgets_hash() and .to_stfl() on your next access.

Furthermore, as part of our Ruby wrapper, $app.screen always points to the toplevel widget object that was used in generating the STFL. (This is typically an object inheriting from Theme::Window (which, as described, inherits from Window, which inherits from StflBase, which uses Stfl.rb from STFL distribution). However, any StflBase-based object could be used, since STFL itself places on restrictions on the toplevel element that is used to initialize/draw a window.)

Since $app.screen is a widget, it allows the usual access to @widgets and @widgets_hash to access all of the children (which means all of the widgets on the screen). Most of the time, however, the widget you want to access is not directly under the parent but under some intermediate element(s) such as VBoxes, HBoxes, menus, etc. and it means you would have to search through a chain of children trees for it. To alleviate that, there is a function $app.screen.all_widgets_hash() which returns all of the widget's children and sub-children in a flat structure, so you can simply call $app.screen.all_widgets_hash['YOUR_WIDGET'] to obtain a reference to your object. Since this is a so commonly used function, even more convenient shorthand exists -- simply $app.screen[CHILD_NAME].

Also, since the Ruby wrapper calls all action handlers with a rich standard set of parameters (window, widget, action, function and event), all the child widgets in the form are generally always available to you by simply calling arg[:window][NAME] in your handler code. Or if arg[:window] is not there, you can access the intended child widget via $app.screen[NAME].

Once you have the object, you can call arbitrary functions on it that affect both internal variables and visual representation in real-time. For example, to read or set the text of a label you would call lbl.var_text and lbl.var_text= "New text!" respectively.  Note that the setter function (.var_text=) operates in real-time-- it will set both the internal variable and the value in STFL, and the change will appear on the screen immediately. However, the getter function (.var_text) will only return the value of the widget's variable 'text', which does not necessarily match its current value on the form. To read the actual value from the form, as well as update the internal variable, call .var_VARNAME_now(), such as .var_text_now().

This way, STFL has been completely abstracted and there are even advantages to not using it directly, but reading STFL documentation will certainly help you better understand how it all works. You'll be able to recognize which parts of Taskman are application-level design and which are simple necessities of STFL.

To see how this works in an upgraded 'Hello, World!'-style example, please just run Taskman with option -w hello2, and after seeing it run also examine the source file in theme/alpine/window/hello2.rb.

On actions:
-----------

In addition to adding children widgets to parents (via parent<< child), one can also add "actions" in the same way. 

Actions are basically functions to execute on events, usually keypresses. For example, pressing ENTER in a field could serve as form's OK function that triggers further processing, or pressing Ctrl+X in create window would create a new task.

Actions can be invisible (be added to widgets and work, but not be visible/advertised anywhere), or they can have a visual representation to be more convenient or better indicate their availability. When they are visible, they are usually found in the window's menu bar. An example of it are all the menu options visible the bottom of the main window as soon as you start the program.

Invisible actions are created by either using obj<< MenuAction.new( name: NAME), which instantiates a stock action, or by creating an action manually and overriding/defining its functionality in more detail (a= MenuAction.new( ...)) and then using obj<< a.
Another way to add invisible (but pre-defined) stock actions to a widget (especially when you want to add many stock actions at once), is to call <your widget>.add_action( :name1, :name2, ...).

On the other hand, actions that have a visible representation are created using Theme::MenuAction( name: NAME), and the rest of the notes apply as for MenuAction above. Examples of these are most commonly found in menus displayed within windows, with their exact look/layout implemented in theme/NAME/MenuAction.rb.

Generally, all your theme-agnostic actions should be implemented in menuaction.rb, and all your theme-specific actions should be implemented in theme/NAME/menuaction.rb. A function in a theme that is generally useful should be adjusted to be generic and added to the basic menuaction.rb.

A chapter on themes and styles:
-------------------------------

Taskman supports both themes (different GUI layouts) and styles (different color schemes).

There is no direct relation between a theme and style. The more general a style is (that is, the more it targets broad widget names and classes rather than specifics), the more likely is it to apply correctly to another theme. (No harm in trying; worst case would be that no selector applies to a particular widget, leaving it unstyled, or that multiple selectors match, of which the most specific one would win.)

There is currently only one theme (GUI layout) available -- Alpine, mimicking the layout of the infamous mail program Pine. At least one more theme needs to be written to actually test the supposedly theme-agnostic code in practice and to make sure different themes are realistically possible. For example, one could make a theme resembling the mail program 'mutt', or something different altogether. If you embark on that journey, get in touch to ensure proper support from my side.

There are currently a couple styles (color schemes) available. The default one is called 'alpine', matching the default theme. Others available are 'none' for no any special styling and 'random' for a completely random color scheme on each display of a window (and best random results are had with --style random --colors 256, if your terminal supports 256 colors - which most Linux terminals do). Style files are very simple and it is expected that they will be customized - or that new ones will be created - much more often than complete themes.

Locally, you can place your themes in ~/.taskman/lib/theme/THEME_NAME/ and design them by using the default Alpine theme as a reference. To use your theme, simply invoke Taskman with -t THEME_NAME.

You can place your styles in ~/.taskman/lib/style/, using existing styles for reference. To use your style, simply invoke Taskman with -s STYLE_NAME.

The most important thing in writing a style is knowing how the element you want to style is called, so that you can write a selector for it. The names will inevitably vary from theme to theme, but it is advised that theme authors follow the names used in the Alpine theme where ever applicable.

Another thing to understand is how styles are applied. For each widget, Taskman determines its hierarchical position in the form and then tries to find the its matching style definition, with decreasing specificity.

For example: when you start Taskman using the default Alpine theme, you will notice the program name and version displayed in the top-left of the window. This widget is called "header_program_name_version", it is of type 'label', and it displays the program name and version.

Taskman is dynamically aware that this widget is a child of 'header', which in turn is a child of 'main' (the main program window), and it tries to apply the style by searching for the style keys in the following order:

"main header header_program_name_version"
"main header @label"
"main header"
"header header_program_name_version"
"header @label"
"header"
"main header_program_name_version"
"main @label"
"main"
"header_program_name_version"
"@label"

Similarly, here's a lookup that takes place when one part (the hotkey label) of one of the available menu actions is being rendered:

"main menu menu_create_hotkey"
"main menu @hotkey"
"main menu @label"
"main menu"
"menu menu_create_hotkey"
"menu @hotkey"
"menu @label"
"menu"
"main menu_create_hotkey"
"main @hotkey"
"main @label"
"main"
"menu_create_hotkey"
"@hotkey"
"@label"

Here, we notice that Taskman searched not only for the widget name and its type (@label), but also for its class name (@hotkey). When the widget's class name does not match its STFL element, Taskman also searches for the class name, allowing for very convenient styling that would otherwise be hard to apply to multiple widgets of otherwise the same type in a single rule.

The search for each style key is done in such a way that Taskman iterates over all defined style keys in your style file, testing them sequentially in the order as they were specified. The first selector that matches "wins".

It is important to know that the selectors in your style definitions can be literal strings, regexes or code blocks. A selector will win (be chosen) if the literal string is equal, the regex matches, or the code block returns true.
Similarly, the actual style definitions for the key can be hashes (specifying values for "normal", "focus" and "selected" styles - but more on that below), or they can be code blocks which are ran and expected to return such hashes. An example of using code blocks can be seen in the style "random", where it is used to randomly color each widget.

It is also useful to know that the style is not applied to widgets that are not to be rendered in STFL (those with @widget= nil). Also, if you change the STFL widget type of an object (for example, if you create a Label but set its @widget to be e.g. 'input'), then after all the "@label" lookups, Taskman wil also search for "@input" before shifting the leftmost element from the path and trying another round.

Also, in searching for styles, Taskman automatically removes the numbers that immediately follow letters at the end of widget names. Specifically, if your widget is named "menu2" and is found under "main", Taskman will search for "main menu", not "main menu2".

Discovering widget names and hierarchy:
---------------------------------------

When writing your style (or modifying an existing one) there are multiple ways in which you can discover the names or the hierarchy of the widgets you want to style:

1. Look up existing definitions in style/alpine.rb. It is possible the selectors are already there and you simply need to change their definitions in your own style file.

2. Look up the program source of the window you are styling, and locate the names of the widgets you are interested in.

3. Run the program with option --debug-stfl and redirect STDERR output to a temporary file, such as:  taskman --debug-stfl 2> /tmp/debug.log. In the debug file, you will see the complete STFL text that was used to produce the current form, and you will be able to find your widget by searching for chunks of text visible in or around it. Alternatively, if you know the name of the toplevel widget or one of its parents, you can narrow the log by dumping only their STFL; you can do this with --debug-stfl-widget WIDGET_NAME.

4. You could also run the program with option --debug-style and redirect STDERR output to a temporary file. The log would show you all style lookups the program has performed, and you could recognize the name of your widget in the list.

Once you have the name of the target widget you want to style, you can run Taskman with option --debug-style-widget WIDGET_NAME (redirecting STDERR to a temp file as usual), and you will see the exact keys being looked up in trying to style the widget. From there, simply pick the one having the desired level of specificity and define a style for it in style/YOUR_STYLE.rb.

Finally, it needs to be said that Taskman directly inherits STFL's styling capabilities, which means that there are 3 styles you can define for each widget: style 'normal', 'focus' and 'selected'.

Style 'normal' is the default representation. Style 'focus' is the representation when the widget is focused. Style 'selected' applies to lists and defines the representation of the selected item in the list when the list itself is not focused.

Taskman also uses direct style syntax that is used by STFL; it is a comma separated list of key=value pairs, where the key can be 'bg' for background, 'fg' for foreground and 'attr' for text attributes.

To define a blue background with white, bold and blinking text on it, you would use:

  "bg=blue,fg=white,attr=bold,attr=blink"

The following fg and bg colors are supported:

	black red green yellow blue magenta cyan white

The following text attributes are supported:

	standout underline reverse blink dim bold protect invis

On terminals that support more than 8 colors (16, 256) it is also possible to use extended colors, by using "color<number>" as color names, where "<number>" is a number between 0 and 255. For a complete chart of numbers and their corresponding colors, you could run "taskman --co 256 -w colortest", or see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html.

(The built-in color test program is invoked with taskman -w colortest, and will display all colors currently supported by your terminal. Adding --colors <NUM> to that would force a specific number of colors and then display the colortest.)

Colors (--co) can set the number of colors to something other than the default 8. The most common color settings are --co 16 and --co 256. (These depend on available terminal types and capabilities in terminfo, can't be arbitrary.)

And one last note, please note that STFL uses the default terminal colors when no background or foreground are specified. Generally, you should avoid specifying only fg= or bg=, as the particular combination of one setting and the terminal's default style for the other might be unreadable.
^+ "\n\n"+
'6. COMMAND LINE OPTIONS'+ "\n"+ $app.usage+ %q^
Enjoy!
^
end
end

