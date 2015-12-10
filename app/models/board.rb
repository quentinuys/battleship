class Board < ActiveRecord::Base
	belongs_to :boardable, polymorphic: :true
end
