class Game::BaseGameCmd < Cmd 

	def initialize(name, email)
		@name = name
		@email = email
	end
end