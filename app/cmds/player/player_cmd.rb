class Player::PlayerCmd < Player::BasePlayerCmd

	attr_reader :player, :ship_cmd

	def execute!
		new_player
		new_player_board
		new_player_ships
	end

private
	
	def new_player
		@player = @game.create_player!()
	end

	def new_player_board
		Board::BoardCmd.new(@player).tap do |cmd|
			cmd.execute!
		end
	end

	def new_player_ships
		@ship_cmd = Ship::ShipCmd.new(@player).tap	do |cmd|
			cmd.execute!
		end
	end

end