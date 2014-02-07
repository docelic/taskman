require 'theme/alpine/head'
require 'theme/alpine/menu'

module TASKMAN
	class MainWindow < Window

		attr_reader :header, :menu

		@@menu= [
			MenuAction.new( :name => :help),
			MenuAction.new( :name => :''),
			MenuAction.new( :name => :prevcmd),
			MenuAction.new( :name => :relnodes),
			MenuAction.new( :name => :other),
			MenuAction.new( :name => :hotkey_in),
			MenuAction.new( :name => :nextcmd),
			MenuAction.new( :name => :kblock),
			MenuAction.new( :name => :help),
			MenuAction.new( :name => :quit),
			MenuAction.new( :name => :listfolders),
			MenuAction.new( :name => :index),
			MenuAction.new( :name => :setup),
			MenuAction.new( :name => :role),
			MenuAction.new( :name => :other),
			MenuAction.new( :name => :create),
			MenuAction.new( :name => :gotofolder),
			MenuAction.new( :name => :journal),
			MenuAction.new( :name => :addrbook),
			MenuAction.new( :name => :'')
		]

		def initialize *arg
			super

			@header= Head.new
			self<< Head.new.children

			self<< v= Vbox.new( :@style_normal => 'bg=black,fg=white')

			self<< s= Hbox.new( :'.expand' => 'h', :@style_normal => 'bg=red,fg=white')
			s<< Label.new( :'.expand' => '0', :@style_normal => 'bg=blue,fg=white', :'text' => ' ')
			s<< Label.new( :@style_normal => 'bg=black,fg=white', :'text' => '')
			s<< Label.new( :'.expand' => '0', :@style_normal => 'bg=blue,fg=white', :'text[status_text]' => '')
			s<< Label.new( :@style_normal => 'bg=black,fg=white', :'text' => '')

			@menu= Menu.new
			self<< h= Menu.new.children

		end

		def apply_menu
			pos= 0
			@actions||= {}
			@@menu.each do |i|
				pfl i.name
				$stfl.set "menu_#{pos}_hotkey_text", i.hotkey.to_s
				$stfl.set "menu_#{pos}_shortname_text", ' '+ i.shortname.to_s
				pos+= 1

				unless @actions[i.hotkey]
					# Register for easier lookup:
					@actions[ i.hotkey.to_s]= i.function
				end
			end
		end
	end
end
