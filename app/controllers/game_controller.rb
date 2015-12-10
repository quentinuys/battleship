class GameController < ApplicationController
	
	def index
		
	end

	def start_game
		initialize_credentials
		new_game
		new_participants

		fire_nuke(@game_result["x"], @game_result["y"])
		@oponent_response = @oponent_nuke.hit_response

		@player_id = @player.id
		@oponent_id = @oponent.id
		
	end

	def draw_ships
		get_players(params)
		@player_ships = @player.ships
		@oponent_ships = @oponent.ships
	end

	def fire_clever_nuke
		binding.pry
		get_players(params)

		player_nuke.fire_clever_nuke!

		@response = @player_nuke.hit_response
		@fired_at = @player_nuke.fired_at_space

		fire_nuke(@response["x"], @response["y"])
		@oponent_response = @oponent_nuke.hit_response

		if @response["game_status"]
			@won = "Yes, prize is: #{@response["prize"]}"
		end
	end

	def fire_nuke(x, y)
		oponent_nuke.fire_nuke!(x, y)
	end

private

	def new_participants
		new_player
		new_oponent
	end

	def initialize_credentials
		@name = params[:name]
		@email = params[:email]
	end

	def new_game
		Game::GameCmd.new(@name, @email).tap do |cmd|
			cmd.execute!
			@game = cmd.game
			@game_result = cmd.game_result
		end
	end

	def new_player
		Player::PlayerCmd.new(@game).tap do |cmd|
			cmd.execute!
			@player = cmd.player
			@player_ship_cmd = cmd.ship_cmd
		end
	end

	def new_oponent
		Oponent::OponentCmd.new(@game).tap do |cmd|
			cmd.execute!
			@oponent = cmd.oponent
			@oponent_ship_cmd = cmd.ship_cmd
		end		
	end

	def new_nukes
		player_nuke
		oponent_nuke
	end

	def get_players(params)
		@oponent = Oponent.where{id == my{params[:oponent_id]} }.first
		@player  = Player.where{id == my{params[:player_id]} }.first
	end

	def player_nuke
		@player_nuke ||= Nuke::NukeCmd.new(@player, @oponent)
	end

	def oponent_nuke
		@oponent_nuke ||= Nuke::NukeCmd.new(@oponent, @player)
	end
end