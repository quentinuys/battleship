class Ship < ActiveRecord::Base
	belongs_to :shipable, polymorphic: :true
end
