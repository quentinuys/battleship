class Game < ActiveRecord::Base
	has_one :player
	has_one :oponent
end
