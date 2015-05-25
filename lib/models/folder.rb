# Representation of the task/item category / group.

module TASKMAN

	class Folder < ActiveRecord::Base
		has_many :categorizations, dependent: :destroy
		has_many :items, through: :categorizations
	end 

end
