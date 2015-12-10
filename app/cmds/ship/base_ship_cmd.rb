class Ship::BaseShipCmd < Cmd
		
  def initialize(participant)
		@participant = participant
		@game = @participant.game
	end

end