class Cmd

	def occupied_board_space(size, direction, x, y)
		space = []
		(0...size).to_a.each do |block|
			if direction == "vertical"
				space << {x:x, y:(y+block)}
			else
				space << {x:(x+block), y:y}
			end
		end
		space
	end
	
end