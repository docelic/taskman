# Representation of the task/item status.

module TASKMAN

	class Status < ActiveRecord::Base
		has_many :items
	end 

end
