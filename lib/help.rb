module TASKMAN
  class Help

		def self.text() @@text end

		@@text= "\n"+
'GENERAL INFORMATION ON THE TASKMAN TASK SCHEDULER'.center + "\n\n"+
"Version #{$opts['version']}".center+ "\n\n"+
"Copyright 2014 Spinlock Solutions".center+ "\n"+
"http://techpubs.spinlocksolutions.com/taskman/".center+ "\n\n"+
%q^

Table of Contents:

1. Basic Information
2. Task Creation & Features
3. Scheduling / Reminder Syntax
4. Developer Overview
5. Command Line Options

^+ '-'* ( $COLUMNS- 1)+ %q^

1. BASIC INFORMATION

Taskman allows creation of task/TODO/event lists and offers extensive scheduling and reminding features.

Scheduling features have been inspired by a program called Remind, although Taskman is more powerful and elaborate.

Default user interface has been inspired by the venerable mailer program Pine (Alpine), although Taskman supports completely customizable layouts ("themes") and color schemes ("styles").

^+ '-'* ( $COLUMNS- 1)+ %q^

2. TASK CREATION & FEATURES

Taskman's functionality revolves around creating tasks and defining their scheduling (recurrence) and reminding options.

Tasks can be created by starting Taskman and navigating to "CREATE TASK" in the main menu, or pressing "C" (case insensitive). From the command line, task creation window can be opened directly by passing option "-w create" to the program.

In the CREATE TASK window, the following (all optional) task attributes can be defined:

1. Subject: task title / summary

2. Start: absolute start date for the task. Before the start date, task will be considered inactive and Taskman will never show it as due or remind you about it. By default, there is no start date (the task is always considered active).

3. End: absolute end date for the task. After the end date, task will be considered inactive and Taskman will never show it as due or remind you about it. By default, there is no end date (the task is always considered active).

4. Time: time of day when the task is due. By default, it is set to 12:00:00.

5. Due dates: days on which the task is due. A task can be due on multiple days, defined as specific dates (e.g. Jan 1, 2015) as well as various repetition rules (e.g. every Monday, every two days between 12th and 22th of a month, etc.).

6. Omit dates: days on which the task should not be due, even if it would otherwise be due on those days. This field accounts for days being holidays, non-working days (weekends) or any other exceptions to the rule. It supports the same syntax as Due dates.

7. Omit shift: behavior in case that a task is due on an omitted day. Task can either be ignored (not triggered) or Taskman can reschedule it, either to the first earlier or first later non-omitted day.

8. Remind: days and times when Taskman should remind you about the upcoming task or event. It can remind on a specific day or relative to the due date. For example, you might desire Taskman to start reminding you 90 minutes before the event and remind a total of 3 times with 10 minutes in between.

9. Omit remind: behavior in case that a reminder is due on an omitted day. Reminder can be ignored (not triggered), or Taskman can remind anyway.

^+ '-'* ( $COLUMNS- 1)+ %q^

3. SCHEDULING / REMINDER SYNTAX

Here's the syntax supported by the above-described fields:

SUBJECT
Syntax: free-form text
Example: Test 123
Example: Meeting with X

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
Example: >2014 (every day in 2014 and onwards)

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

4. DEVELOPER OVERVIEW

Taskman execution starts in main.rb. It loads all Ruby and local modules, defines and parses command line options, prints --help if it was requested, and defines the TASKMAN::Application class which represents the application (similar to how Qt would do it).

The following global variables are available at all times:

1. $LINES (int), $COLUMNS (int) - terminal height and width
2. $opts (hash) - current program options (defaults modified by command line)
3. $getopts (array) - getopt definition (probably not relevant if not doing something specifically related to parsing command line options)
4. usage() - function that displays help
5. $app (object) - instance of TASKMAN::Application. Most useful methods are $app.ui (STFL object) and $app.screen (Ruby objects of toplevel element visible on screen)
6. $tasklist (object) - tasklist, with tasks in $tasklist.tasks hash. $tasklist.data is what gets saved to and loaded from ~/.tasklist/tasks.yaml.

Main loop:
----------

Once main.rb sets things up, it initializes $app and calls $app.start().

$app.start() in current version just loads tasklist and calls $app.exec() which gets the wheels spinning. $app.exec() initializes the window that it has to display, and runs its main loop.

Note that this same function ($app.exec()) is used when switching from one window to another, and that the main loop is based around STFL's main loop implementation + a couple conveniences which you don't need to be implementing yourself:

1) Our main_loop runs in the context of a window, instead of globally, so the current window object is always readily available as 'self'. Similarly, all functions that Taskman's core calls are called with a rich set of arguments, allowing for easy/comfortable implementation of various handlers, menu actions, etc.

2) The main loop automatically sets current widget object (instead of you having to look for it manually), and it automatically displays the focused widget's tooltip in the "status" line, if the focused widget has one and the status widget exists on the current form.  An example of this is e.g. seeing syntax help in the status line while you are pressing Up/Down over various options when creating a new task.

3) If the widget currently under focus has an action associated with it, the main loop automatically adjusts the "hotkey" entry in the window menu, if "hotkey_in" action exists on the current form.  (If there are multiple actions associated, it takes the first one.) An example of this is e.g. when you are in program's main window and are pressing Up/Down to move between the options (create task, task index, etc.). The Hotkey field in the menu at the bottom changes automatically.

4) If ENTER is pressed on a widget, the main loop will automatically execute its first action, if one is associated with it.  An example of this is e.g. when you are in the program's main window and you press ENTER on 'CREATE TASK' in the list. It executes the associated action which opens the Create Task window.

5) Keypresses other than ENTER which are not handled by the widget go through a search list: we check whether the key pressed matches any of the hotkeys associated with the widget itself, then the window's menus, then all the widget's parents up to the top of the tree.  An example of this is e.g. when you are in the CREATE TASK window, and press Ctrl+X to create the task. The Ctrl+X is a hotkey matching one of the entries in the window's menu, and it gets executed.

Now, on STFL:
-------------

In its essence, STFL is a textual GUI definition language and it is not object-oriented. In Taskman, a complete wrapper has been written so that you would only manipulate Ruby objects, and the STFL part would automagically take care of itself.

For example, to create a window named "Hello" and display a label in it, you would simply call:

module TASKMAN
  class Theme::Window::Hello < Theme::Window

		def initialize *arg
			super
			@widget= 'vbox'
			self<< Label.new( :name => 'lbl1', :text => 'Hello, World!')
		end

	end
end

If you saved that to a file theme/alpine/window/hello.rb and ran 'ruby main.rb -w hello', it would work! (In fact, that file exists in the Taskman distribution for demonstration purposes; simply run taskman with '-w hello' to see it.)

Insights to pick up from that example:

1) Every class wishing to use STFL needs to inherit from one of STFL-derived classes (in this case Theme::Window), which ultimately all inherit from another class named StflBase, which in turn uses Stfl.rb that comes from the STFL distribution.

2) When a window (or any StflBase-derived object) needs to be converted to STFL text, it happens via calling .to_stfl() on it. That function is defined in stfl_base.rb and it outputs a desired element in STFL with the corresponding name and options, and it also STFL-izes all its children elements and returns the complete STFL.  If the object has no name (because it is e.g. just a supporting element that you will never want to access or be interested in, such as a supporting HBox or VBox) then its name will be autogenerated, in the pattern of W_0, W_1, W_2, etc.

3) The toplevel STFL element seen after .to_stfl() is coming from instance variable @widget, and all typical widget types (such as label, checkbox etc., found in the widget/ subdirectory) have their values for @widget appropriately set.  But you could use an arbitrary name (for no obvious benefit though), or also @widget = nil to just STFL-ize the children without creating a STFL representation of the current object.

4) In the example, we can also see the syntax "self<< Label.new( ...)".  The "<<" is an operator defined also in stfl_base.rb, and it is used to add a widget (Label in our case) as a child of parent ('self' in our case).  It does this by adding a widget to parent's variables @widgets and @widgets_hash, and also handles hotkeys if the child being added is a MenuAction instead of a simple widget. In any case, please always use 'parent<< child' instead of manually manipulating the described variables.

5) Final thing to know is that STFL language is flat, there is no hierarchy and all elements can be accessed by their name directly from toplevel.

$app.ui always points to the current STFL form, and it allows one to e.g.  read form value of e.g. an input field by simply calling $app.ui.get 'OBJ_NAME_text'. This is basic, standard STFL usage as one would learn from reading STFL docs.

On the other side, our Ruby wrapper is much more elaborate. First of all, it is aware of the hierarchy. Each widget has a .parent() pointing to its parent, and @widgets/@widgets_hash pointing to its children. When << is used, it forcibly sets child widget's parent to the widget it was added to. (Similar to how Qt does it.) It is also what allows one to call widget.to_stfl() and get the complete structure of Ruby objects (the parent and all children) converted to STFL text ready for displaying on the screen.

$app.screen always points to the toplevel widget that was used in generating the STFL. (This is typically an object inheriting from Theme::Window, which inherits from Window, which inherits from StflBase, which uses Stfl. However, any StflBase-based object could be used.)

Since $app.screen is a widget, it allows the usual access to @widgets and @widgets_hash to access all of the children (which means all of the widgets on the screen). Most of the time, however, the widget you want to access is not directly under the parent but under some intermediate element(s), such as VBoxes, HBoxes, menus, etc. and it means you would have to search through a chain of children trees for it. To alleviate that, there is a function $app.screen.all_widgets_hash() which returns all of the widget's children and sub-children in a flat structure, so you can simply call $app.screen.all_widgets_hash['YOUR_WIDGET'] to obtain a reference to your object.

In fact, since accessing a child widget is so common task, calling widget['NAME'] has been enabled and it is an alias for widget.all_widgets_hash['NAME']. Furthermore, since the Ruby wrapper calls all action handlers with a rich standard set of parameters (window, widget, action, function and event), all the child widgets in the form are generally always available to you by simply calling arg[:window]['NAME'] in your handler code. Or if arg[:window] is not there, you can access the intended child widget via $app.screen['NAME'].

Once you have the object, you can call arbitrary functions on it that affect the variables and display in real-time. For example, to read or set the text of a label you would call lbl.var_text and lbl.var_text= "New text!" respectively.  Note that the setter function (.var_text=) operates in real-time-- it will set both the internal variable and the value in STFL, and the change will appear on the screen immediately. The getter function (.var_text) will only return the value of the widget's variable 'text', which does not necessarily match its current value on the form. To read the actual value from the form, as well as update the internal variable, call .var_NAME_now(), such as .var_text_now().

This way, STFL has been completely abstracted and there are even advantages to not using it directly, but reading STFL documentation will certainly help you better understand how it all works. You'll be able to recognize which parts of Taskman are application-level design and which are simple necessities of STFL.

To see how this works in an upgraded 'Hello, World!'-style example, please just run Taskman with option -w hello2, and after seeing it run also examine the source file in theme/alpine/window/hello2.rb.

On actions:
-----------

In addition to adding children widgets to parents (via parent<< child), one can also add "actions" in the same way. 

Actions are basically functions to execute on events, usually keypresses. For example, pressing an ENTER in a field could serve as form's OK function that triggers further processing, or pressing Ctrl+X in create window would create a new task.

Actions can be invisible (be added to widgets and work, but not be visible anywhere), or they can have a visual representation to be more convenient or indicate their availability. When they are visible, they are usually found in the window's menu bar. An example of it are all the menu options visible the bottom of the main window as soon as you start the program.

On themes and styles:
---------------------

Taskman supports both themes (different GUI layouts) and styles (different color schemes).

There is no direct relation between a theme and style. The more general a style is (that is, the more it targets broad widget names and classes rather than specifics), the more likely it is to work with another theme. 

There is currently only one theme available -- Alpine, mimicking the layout of the infamous mail program Pine. At least one more theme needs to be written to actually test the supposedly theme-agnostic code in practice and to make sure different themes are realistically possible. For example, one could make a theme resembling the mail program 'mutt'.

There is currently only one style available, matching the default theme. Style files are very, very simple and it is expected that they will be tuned or that new ones will be created much more often than themes.

Locally, you can place your themes in ~/.taskman/lib/theme/THEME_NAME/ and design them by using the default Alpine theme as a reference. To use your theme, simply invoke Taskman with -t THEME_NAME.

You can place your styles in ~/.taskman/lib/style/. To use your style, simply invoke Taskman with -s STYLE_NAME.

The most important thing in writing a style is knowing what the element you want to style is called, so that you can write a selector for it. The names will inevitably vary from theme to theme, but it is advised that theme authors follow the names used in the Alpine theme where ever applicable.

Another thing to understand is how styles are applied. For each widget, Taskman determines its hierarchical position in the form and then tries finding a matching style definition with less and less specificity.

For example: when you start Taskman using the default Alpine theme, you will notice the program name and version displayed in the top-left of the window. This widget is called "header_program_name_version", it is of type 'label', and it serves an obvious purpose.

Taskman is dynamically aware that this widget is a child of 'header', which in turn is a child of 'main' (the main program window), and it tries to apply style to it by searching for the following style keys:

"main header header_program_name_version"
"main header @label"
"main header"
"header header_program_name_version"
"header @label"
"header"
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
"menu_create_hotkey"
"@hotkey"
"@label"

Here, we notice that Taskman searched not only for widget name and its type (@label), but also for its class name (@hotkey). When the widget's class name does not match its STFL element, we also search for the class name, allowing for very convenient styling that would otherwise be hard to apply to multiple widgets in a single rule.

The first selector that is found "wins" and no further lookups are made for that widget.

It is also useful to know that style is not applied to widgets that are not to be rendered in STFL (those with @widget= nil). Also, if you change the STFL widget type of an object (for example, if you create a Label but set its @widget to be e.g. 'input'), then after all the "@label" lookups above Taskman would also search for "@input" before shifting the leftmost element from the path and trying another round.

Also in searching for styles, Taskman automatically removes the numbers that immediately follow letters in the widget names. Specifically, if your widget is named "menu2" and is found under "main", Taskman will search for "main menu", not "main menu2".

Discovering widget names and hierarchy:
---------------------------------------

There are multiple ways in which you can discover the names or hierarchy of the widgets you want to style:

1. Look up existing definitions in style/alpine.rb. It is possible the selectors are already there and you simply need to change their definitions.

2. Look up the program source of the window you are styling, and locate the name of the widget you are interested in. (Taskman is open source Ruby code after all.)

3. Run the program with option --debug-stfl and redirect STDERR output to a temporary file, such as:  taskman --debug-stfl 2> /tmp/debug.log. In the debug file, you will see the complete STFL text that was used to produce the current form, and you will be able to find your widget by searching for chunks of text visible in or around it. Alternatively, if you know the name of the widget or one of its parents, you can narrow the log by dumping their STFL only; you can do this with --debug-stfl-widget WIDGET_NAME.

4. You could also run the program with option --debug-style and redirect STDERR output to a temporary file. The log would show you all style lookups the program has performed, and you could recognize the name of your widget in the list.

Once you have the name of the target widget you want to style, you can run Taskman with option --debug-style-widget WIDGET_NAME (redirecting STDERR to a temp file as usual), and you will see the exact keys being looked up in trying to style the widget. From there, simply pick the one having the desired level of specificity and define a style for it in style/YOUR_STYLE.rb.

Finally, it needs to be said that Taskman directly inherits STFL's styling capabilities, which means that there are 3 styles you can define for each widget: style 'normal', 'focus' and 'selected'.

Style 'normal' is the default representation. Style 'focus' is the representation when the widget is focused. Style 'selected' applies to lists and defines the representation of the selected item in the list when the list itself is not focused.

Taskman also uses style syntax that is used by STFL; it is a comma separated list of key=value pairs, where the key can be 'bg' for background, 'fg' for foreground and 'attr' for text attributes.

To define a blue background with white, bold and blinking text on it, you would use:

  "bg=blue,fg=white,attr=bold,attr=blink"

The following fg and bg colors are supported:

	black red green yellow blue magenta cyan white

The following text attributes are supported:

	standout underline reverse blink dim bold protect invis

On terminals that support 256 colors it is also possible to use extended colors, by using "color<number>" as color name, where "<number>" is a number between 0 and 255. For a complete chart of numbers and their corresponding colors, please see http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html.

Taskman also contains a built-in color test program. Simply invoke taskman -w colortest to see the colors and color codes available in your terminal.

One last note, please note that STFL uses the default terminal colors when no background or foreground are specified. Generally, you should avoid specifying only fg= or bg=, as the particular combination of one setting and the terminal's default style might be unreadable.


TODO:
On themes
On actions-- how the idea is to have them in menuaction, and themes free of code
^+ "\n\n"+
'COMMAND LINE OPTIONS'.center + "\n"+ usage
end
end

