module TASKMAN
  class Install

		def self.text() @@text end

		opts= TASKMAN::Defaults.new

		@@text= "\n"+
'TASKMAN TASK SCHEDULER - INSTALL INFORMATION'.center + "\n\n"+
"Version #{opts['version']}".center+ "\n"+
"#{Time.now.utc.iso8601}".center+ "\n\n"+
"Copyright 2014-2015 Spinlock Solutions".center+ "\n"+
"http://techpubs.spinlocksolutions.com/taskman/".center+ "\n\n"+
%q^

Table of Contents:

1. Prerequisites
1.1. Packages
1.2. Ruby and Ruby GEMs
1.3. STFL
1.4. Taskman
1.5. MySQL
1.6. Taskman Database Configuration
2. Running Taskman


^+ '-'* ( $COLUMNS- 1)+ %q^

1. PREREQUISITES

To run Taskman, you need some generic software packages plus Ruby >= 1.9, a couple Ruby GEMs, STFL and MySQL.

1.1. Software Packages:
-----------------------

sudo apt-get install swig mysql-server libmysqlclient-dev libncurses5-dev libncursesw5-dev

1.2. Ruby and Ruby GEMs:
------------------------

sudo gem install gettext activerecord mysql2 ruby-terminfo

1.3. STFL:
----------

STFL is a "Structured Terminal Forms Language/Library", available at http://www.clifford.at/stfl/.

Minimum STFL version required is 0.24.

Please pay attention that ruby/stfl.so exists, which it will if 'swig' and Ruby header/development files have been installed:

wget http://www.clifford.at/stfl/stfl-0.24.tar.gz
tar zvxf stfl-0.24.tar.gz
cd stfl-0.24
make
ls -al ruby/stfl.so # <-- Must be present
sudo make install
sudo ldconfig

1.4. Taskman:
-------------

git clone https://github.com/docelic/taskman.git

1.5. MySQL:
-----------

Once MySQL server is installed, the following configuration has to be performed:

sudo -H mysql -e 'create database taskman'
sudo -H mysql taskman < sql/taskman.sql
mysql taskman -e "GRANT ALL PRIVILEGES ON taskman.* TO taskman@'localhost' IDENTIFIED BY 'taskman'"

This will create the database and grant permissions on the default database to the default user and default password. Taskman has already been preconfigured to use these defaults.

If you want to change these defaults, please do so and then read the following section.

1.6. Taskman Database Configuration:
------------------------------------

By default, Taskman connects to the local MySQL database 'taskman' as user 'taskman' with the password 'taskman'.

It is suggested to change these values and then create or modify Taskman configuration to use the correct connection information.

The default configuration file is ~/.taskman/taskmanrc. Please create it with the following content (and with adjusting any values as necessary):

--conn "main:[adapter:'mysql2',host:'localhost',username:'taskman', password:'taskman',database:'taskman']"

** NOTE: The above should all be on a single line. Also, quotes must remain as-is and there must be no any whitespace in the quoted string!

^+ '-'* ( $COLUMNS- 1)+ %q^

2. RUNNING TASKMAN

When all the prerequisites have been installed and the MySQL configuration data is in place, Taskman options can be seen with:

taskman -h

A default GUI can be opened with:

taskman

A 256-color theme can be opened with:

taskman --theme desert --colors 256

** NOTE: Keys like HOME/END/PGUP/PGDOWN seem to not work if --colors 256 is specified. (This is because the option --colors changes the terminal's TERM variable, inadvertently also affecting the keys.)

Enjoy!
^
end
end

