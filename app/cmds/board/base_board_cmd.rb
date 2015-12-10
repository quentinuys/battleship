require 'cmd'
class Board::BaseBoardCmd < Cmd

	def initialize(participant)
		@participant = participant
	end

	def execute!
		create_board
	end

private

	def create_board
		@participant.create_board!(height: height, width: width, grid_height: grid_height, grid_width: grid_width)
	end

	def grid_height
		10
	end

	def grid_width
		10
	end

	def width
		600
	end

	def height
		600
	end
end