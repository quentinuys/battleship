require 'spec_helper'

describe Player::PlayerCmd do
	before do
		DatabaseCleaner.clean
	end

	let(:game) { FactoryGirl.create(:game) }

	let(:cmd) { Player::PlayerCmd.new(game) }

	context "Create Player " do
		before do
			cmd.stubs(:new_player_board).returns true
			cmd.execute!
		end
		subject{game.player}

		its(:id) { should eq(1) }

	end
end