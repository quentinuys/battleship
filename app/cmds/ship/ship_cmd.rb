class Ship::ShipCmd < Ship::BaseShipCmd

	def execute!
		create_ships_random
	end

	def execute_empty!
		create_empty_ships
	end

	def update_ship!(name, status, x, y, direction = nil)
		update_ship(name, status, x, y, direction)
	end

private

	def update_ship(name, status, x, y, direction)
		empty_ship = @participant.ships.where{(name == my{name}) & (status == "live")}.first
		exist_ship = @participant.ships.where{(name == my{name}) & (status == "live") & (location_x == my{x}) & (location_y == my{y}) }.first

		ship = exist_ship || empty_ship
		
		ship.direction ||= direction
		ship.update_attributes(location_x: x, location_y: y, status: status)
		ship.save!
	end

	def create_empty_ships
		ship_types.each do |ship|
			@participant.ships.create!(name: ship[:name], size: ship[:size], status: "live", location_x: nil, location_y: nil, direction: nil)
		end
	end

	def create_ships_random
		ship_types.each do |ship|
			rand_ship = random_ship_location(ship[:size])
			@participant.ships.create!(name: ship[:name], size: ship[:size], status: "live", location_x: rand_ship[:x], location_y: rand_ship[:y], direction: rand_ship[:direction])
		end
	end

	def random_ship_location(ship_size)
		@grid_size = 10
		@ship_size = ship_size
		begin
			@x = rand(@grid_size) + 1
			@y = rand(@grid_size) + 1
			@direction = directions[rand(2)-1]
		end while !valid_ship?

		{x: @x, y: @y, direction: @direction}

	end

	def existing_ships?
		@participant.ships.any?
	end

	def intersecting_ship?
		new_ship = occupied_board_space(@ship_size, @direction, @x, @y)
		if existing_ships?
			@participant.ships.each do |ship|
				old_ship = occupied_board_space(ship.size, ship.direction, ship.location_x, ship.location_y)
				return true if collide?(old_ship, new_ship)
			end
			false
		else
			false
		end
	end

	def collide?(ship_one, ship_two)
		ship_two.each do |sp|
			return true if ship_one.include?(sp)
		end
		false
	end

	def inbounds?
		if @direction == "vertical"
			((@ship_size + @y) < @grid_size )
		else
			((@ship_size + @x) < @grid_size )
		end
	end

	def valid_ship?
		return true if (intersecting_ship? == false and inbounds? == true)
		false
	end

	def directions
		["vertical", "horizontal"]
	end

	def ship_types
		[
			{
				name: "Carrier",
			  size: 5
			},
			{ 
				name: "Battleship",
				size: 4
			},
			{ 
				name: "Destroyer",
				size: 3
			},
			{ 
				name: "Submarine",
				size: 2
			},
			{ 
				name: "Submarine",
				size: 2
			},
			{
				name: "Patrol Boat",
				size: 1
			},
			{
				name: "Patrol Boat",
				size: 1
			}
		]
	end
end