module TASKMAN

	class List < Widget

		def initialize *arg
			super
			@widget= 'list'

			self<< MenuAction.new( name: :top_list)
			self<< MenuAction.new( name: :bottom_list)

			@prev_offset= nil
		end

	end

	class MVCList < List

		def mvc
			o= self.var_offset_now
			h= self._h_now

			if @prev_offset!= o # @prev_offset== -1
				p= self.var_pos_now
				#diff= o- @prev_offset
				#limit= self._h_now
				#if diff> 0
				#	h= self._h_now
				#	spos= o+ h
				#else
				#	spos= o+ diff
				#end
				# TODO: This can be improved by always only requesting what is
				# visible on screen (or even better, just differences), and then
				# using STFL modify() appropriately.
				# And handling home/end, pgup/pgdown manually.
				from= [ o- h, 0].max
				to= o+ 2* h

				self>> ListItem
				tasks= $tasklist.get from, to
				# Here the result in tasks is like:
				# [
				#   [ dbname, task_obj],
				#   [ dbname, task_obj],
				#   ...
				# ]
				# But ruby automatically maps s/t below to array,
				# very wonderful!
				tasks.each do |s, t|
					nid= [ s, t].to_id_s # nid== "name/id" string
					s= self.parent.fmt % [ t.id, s, t.subject]
					self<< ListItem.new( name: nid, text: s, can_focus: 1)
				end
				self.clear_caches
				self.var_offset= o
				self.var_pos= p
				self.replace
			end
			@prev_offset= o
		end
	end

	class ListItem < Widget

		def initialize *arg
			super
			@widget= 'listitem'
		end
	end
end
