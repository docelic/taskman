# Representation of the task/item category / group.

module TASKMAN

	class ItemCategory < ActiveRecord::Base
		belongs_to :item
		belongs_to :category
	end 

end
