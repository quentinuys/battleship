require 'httparty'
require 'json'

class Nuke::NukeCmd < Nuke::BaseNukeCmd
	attr_reader :hit_response, :fired_at_space

	def fire_nuke!(x, y)
		@x = x	
		@y = y
		nuke_it
		get_hit_response
		update_response
	end

	def fire_clever_nuke!
		nuke_clever
		get_remote_hit_response
		hit_response_json
		update_response
	end

private

	def nuke_it
		@nuke = @participant.nukes.create!(x_position: @x, y_position: @y, status: nil)
	end

	def nuke_clever
		nuke_spot = random_nuke if !last_hit? || last_hit_sunk?
		nuke_spot ||= clever_nuke.any? ? clever_nuke.first : clever_nuke_two.any? ? clever_nuke_two.first : random_nuke
		@x = nuke_spot[:x]
		@y = nuke_spot[:y]
		@fired_at_space = {"x"=>@x, "y"=>@y}
		nuke_it
	end

	def get_remote_hit_response
		@hit_response_raw = HTTParty.post(api_nuke_url, body: {"id"=>@id, "x"=>@x, "y"=>@y}.to_json, headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'} )
	end

	def get_hit_response
		ship = ship_hit
		if ship
			status = "hit"
			sunk = ship_has_sunk?(ship) ? ship.name : nil
		else
			status = "miss"
			sunk = nil
		end
		game_status = game_lost? ? "lost" : nil

		@hit_response = {"id"=>@id, "x"=>@x, "y"=>@y, "status"=>status, "sunk"=>sunk, "game_status"=>game_status, "error"=>nil, "prize"=>nil }
	end

	def game_lost?
		@participant.ships.where{status == "live"}.none?
	end

	def ship_has_sunk?(ship)
		occupied_board_space(ship.size, ship.direction, ship.location_x, ship.location_y).each do |sp|
			return false if @participant.nukes.where{(x_position == sp[:x]) & (y_position == sp[:y])}.none?
		end
		true
	end

	def ship_hit
		@oponent.ships.each do |ship|
			occupied_board_space(ship.size, ship.direction, ship.location_x, ship.location_y).each do |space|
				return ship if ((space[:x] == @x) & (space[:y] == @y))
			end
		end
		nil
	end

	def update_response
		@nuke.update_attributes!(status: status)
		if ship_sunk_name
			ship = @oponent.ships.where{(name == my{ship_sunk_name}) & (status == "live")}.first
			ship.update_attributes!(status: "sunk")
		end
	end

	def last_hit
		@participant.nukes.where{status == "hit"}.last
	end

	def last_hit?
		@participant.nukes.where{status == "hit"}.any?
	end

	def second_last_hit
		@participant.nukes.where{status == "hit"}.order("created_at DESC").offset(1).limit(1).first
	end

	def second_last_hit?
		@participant.nukes.where{status == "hit"}.order("created_at DESC").offset(1).limit(1).any?
	end

	def last_hit_sunk?
		ships_sunk.each do |ss|
			return true if ((ss.location_x == last_hit.x_position) & (ss.location_y == last_hit.y_position))
		end
		false
	end

	def ships_sunk
		@oponent.ships.where{status == "sunk"}
	end

	def ships_sunk?
		ships_sunk.any?
	end

	def fired_at
		fired_at = []
		@participant.nukes.each{|nuke| fired_at << {x: nuke.x_position, y: nuke.y_position}}
		fired_at
	end

	def board_space
		@board_space ||= calculated_board_space
	end

	def random_nuke
		available_nuke_space.sample
	end

	def clever_nuke
		hit_x = last_hit.x_position
		hit_y = last_hit.y_position
		available_nuke_space.select{|sp| ((sp[:x] == hit_x) & ((hit_y == (sp[:y] + 1)) || (hit_y == (sp[:y] - 1)))) || ((sp[:y] == hit_y) & ((hit_x == (sp[:x] + 1)) || (hit_x == (sp[:x] - 1)))) }
	end

	def clever_nuke_two
		hit_x = second_last_hit.x_position
		hit_y = second_last_hit.y_position
		available_nuke_space.select{|sp| ((sp[:x] == hit_x) & ((hit_y == (sp[:y] + 1)) || (hit_y == (sp[:y] - 1)))) || ((sp[:y] == hit_y) & ((hit_x == (sp[:x] + 1)) || (hit_x == (sp[:x] - 1)))) }
	end

	def calculated_board_space
		board_space = []

		width ||= @participant.board.grid_width
		height ||= @participant.board.grid_height

		(0...width).to_a.each do |x|
			(0...height).to_a.each do |y|
			  board_space << {x:x, y:y}
			end		
		end
		board_space
	end

	def hit_response_json
		puts "--------------------------------------------"
		puts @hit_response_raw
		puts "--------------------------------------------"
		@hit_response = @hit_response_raw #.parsed_response
	end

	def available_nuke_space
		board_space.reject{|bs| fired_at.include?({x:bs[:x], y:bs[:y]}) }
	end

	def status
		@hit_response["status"]
	end

	def api_nuke_url
		"#{ENV['API_URL']}nuke"
	end

	def ship_sunk_name
		@hit_response["sunk"]
	end
	
end