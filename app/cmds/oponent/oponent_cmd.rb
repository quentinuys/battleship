class Oponent::OponentCmd < Oponent::BaseOponentCmd

	attr_reader :oponent, :ship_cmd

	def execute!
		new_oponent
		new_oponent_board
		new_empty_ships	
	end

private
	
	def new_oponent
		@oponent = @game.create_oponent!()
	end

	def new_oponent_board
		Board::BoardCmd.new(@oponent).tap do |cmd|
			cmd.execute!
		end
	end

	def new_empty_ships
		@ship_cmd = Ship::ShipCmd.new(@oponent).tap do |cmd|
			cmd.execute_empty!
		end
	end

end