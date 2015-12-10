class Oponent < ActiveRecord::Base
	belongs_to :game
	has_many :ships, as: :shipable
	has_many :nukes, as: :nukeable
	has_one :board, as: :boardable
end
