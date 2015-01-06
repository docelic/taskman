# Representation of the task/item category / group.

module TASKMAN

	class Category < ActiveRecord::Base
		has_many :item_categories, dependent: :destroy
		has_many :items, through: :item_categories
	end 

end
