# Representation of the task/item category / group.

module TASKMAN

	class Categorization < ActiveRecord::Base
		belongs_to :item
		belongs_to :folder
	end 

end
