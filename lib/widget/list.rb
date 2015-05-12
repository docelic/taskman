module TASKMAN

	class List < Widget

		def initialize *arg
			super
			@widget= 'list'

			self<< MenuAction.new( name: :top_list)
			self<< MenuAction.new( name: :bottom_list)
			self<< MenuAction.new( name: :whereis, hotkey: '/')
			self<< MenuAction.new( name: :whereis_reverse)

			@prev_offset= nil

			@wanted_from= 0
			@wanted_to= 0
			@visible_from= 0
			@visible_to= 0
		end

		def init arg= {}
			if arg[:pos]
				self.var_pos= arg[:pos]
			elsif arg[:pos_name]
				n= arg[:pos_name].to_s
				i= 0
				@widgets.each do |t|
					if n== t.name
						self.var_pos= i
					end
					i+= 1
				end
			end
		end

		# Implementation of pos setter which respects max number of items
		# in a list and prevents crashes
		def var_pos=( arg)
			if arg< 0 then arg= 0 end
			max= @widgets.size- 1
			p= [ arg, max].min
			$app.ui.set "#{@name}_pos", ( @variables['pos']= p).to_s
		end

	end

	class MVCList < List

		def mvc arg= {}
			o= self.var_offset_now
			h= self._h_now

#			if @prev_offset!= o or arg[:force]# @prev_offset== -1
				p= self.var_pos_now
#
#				# Let's do the logic this way -- we want 5 screens of data available:
#				# 2 before the current page, current page, and 2 after.
#				# And we load new data if we have less than 1 screen left in either
#				# direction.
#				@visible_from= o
#				@visible_to= o+ h
#
#				# TODO: add prevention for always trying to load near end of list,
#				# if really no more data is available.
#				if((( @wanted_from!= 0 or @widgets.size<= 1) and( @visible_from- @wanted_from <= h)) or @wanted_to- @visible_to <= h)
#					@wanted_from= [ o- 2* h, 0].max
#					@wanted_to= o+ 3* h
#					if debug? :mvc
#						pfl "MVC: Want/need: %d-%d, visible: %d-%d, h: %d; ensuring." % [ @wanted_from, @wanted_to, @visible_from, @visible_to, h]
#					end
#					$tasklist.ensure @wanted_from, @wanted_to
#				end
#
				# A one-off to handle situation where the initial list is pre-populated
				# with one empty entry. (Just for the focus to work and STFL to not
				# segfault.)
				#if @widgets.size== 1
#				pfl self.class, self.name
#					self>> ListItem
#				#end
#
#				#set= $tasklist.tasks[@widgets.count..-1]
##				s= :main
#				$session.sth.each do |t|
##					id= [ s, t.id].to_id_s # id== "name/id" string
#					#s= self.parent.fmt% [ t.flag, t.id, s, t.subject]
#					self<< ListItem.new( name: t.id.to_s, text: s, can_focus: 1)
#				end
#				#if $session.sth.size> 0
#					self.clear_caches
#					#self.var_offset= o
#					#self.var_pos= p
#					self.replace_outer
#					#self.widgets.each do |w| w.apply_style end
#				#end
			#end
#			@prev_offset= o
		end
	end

	class ListItem < Widget

		def initialize arg= {}
			super
			@widget= 'listitem'
		end

	end
end
