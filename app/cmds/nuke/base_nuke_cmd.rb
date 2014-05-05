class Nuke::BaseNukeCmd < Cmd 

	def initialize(participant, oponent)
		@participant = participant
		@oponent = oponent
		@game = @participant.game
		@id = @game.battleship_id
	end

end