require 'httparty'
require 'json'

class Game::GameCmd < Game::BaseGameCmd

	attr_reader :game, :game_result

	def execute!
		register_game
		get_json
		create_game
	end

	def register_game
		@game_result_raw = HTTParty.post(api_register_url, body: {"name"=>@name, "email"=>@email}.to_json, headers: { 'Content-Type' => 'application/json', 'Accept' => 'application/json'} )
	end

	def create_game
		@game ||= Game.create!(battleship_id: battleship_id, name: @name, email: @email, game_status: "busy", prize: nil)
	end

private

	def api_register_url
		"#{ENV['API_URL']}register"
	end

	def get_json
		puts "----------------------------------------"
		puts @game_result_raw
		puts "----------------------------------------"
		@game_result = @game_result_raw #.parsed_response
	end

	def battleship_id
		@game_result["id"].to_i
	end

end