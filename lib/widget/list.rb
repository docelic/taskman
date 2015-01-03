module TASKMAN

	class List < Widget

		def initialize *arg
			super
			@widget= 'list'

			self<< MenuAction.new( name: :top_list)
			self<< MenuAction.new( name: :bottom_list)

			@prev_offset= nil

			@wanted_from= 0
			@wanted_to= 0
			@visible_from= 0
			@visible_to= 0
			
			@tasks= []
		end

	end

	class MVCList < List

		def mvc arg= {}
			o= self.var_offset_now
			h= self._h_now

			if @prev_offset!= o or arg[:force]# @prev_offset== -1
				p= self.var_pos_now

				# Let's do the logic this way -- we want 5 screens of data available:
				# 2 before the current page, current page, and 2 after.
				# And we load new data if we have less than 1 screen left in either
				# direction.
				@visible_from= o
				@visible_to= o+ h

				# TODO: add prevention for always trying to load near end of list,
				# if really no more data is available.
				if((( @wanted_from!= 0 or @widgets.size<= 1) and( @visible_from- @wanted_from <= h)) or @wanted_to- @visible_to <= h)
					@wanted_from= [ o- 2* h, 0].max
					@wanted_to= o+ 3* h
					if debug? :mvc
						pfl "MVC: Want/need: %d-%d, visible: %d-%d, h: %d; ensuring." % [ @wanted_from, @wanted_to, @visible_from, @visible_to, h]
					end
					$tasklist.ensure @wanted_from, @wanted_to
				end

				# A one-off to handle situation where the initial list is pre-populated
				# with one empty entry. (Just for the focus to work and STFL to not
				# segfault.)
				if @widgets.size== 1
					self>> ListItem
				end

				# here the result in tasks is like:
				# [
				#   [ dbname, task_obj],
				#   [ dbname, task_obj],
				#   ...
				# ]
				# but ruby automatically maps s/t below to array, very wonderful!
				#
				# We produce 'set' first to see if there are any new tasks to add,
				# as we're not doing anything if there aren't.
				set= $tasklist.tasks[@widgets.count..-1]
				set.each do |s, t|
					nid= [ s, t.id].to_id_s # nid== "name/id" string
					s= self.parent.fmt% [ t.id, s, t.subject]
					self<< ListItem.new( name: nid, text: s, can_focus: 1)
				end
				if set.size> 0
					self.clear_caches
					self.var_offset= o
					self.var_pos= p
					self.replace
					self.widgets.each do |w| w.apply_style end
				end
			end
			@prev_offset= o
		end
	end

	class ListItem < Widget

		def initialize arg= {}
			super
			@widget= 'listitem'
		end

	end
end
