# Representation of the task/item priority.

module TASKMAN

	class Priority < ActiveRecord::Base
		belongs_to :item
	end 

end
