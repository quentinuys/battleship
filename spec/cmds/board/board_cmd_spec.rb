require 'spec_helper'

describe Board::BoardCmd do

	before do
		DatabaseCleaner.clean
	end

	let!(:player) { FactoryGirl.create(:player) }
	let!(:oponent) { FactoryGirl.create(:oponent) }

	let(:player_board_cmd) { Board::BoardCmd.new(player) }
	let(:oponent_board_cmd) { Board::BoardCmd.new(oponent) }

	context "Player Board" do
		before{player_board_cmd.execute!}
		subject{player.board}
		its(:height) { should eq(600) }
		its(:width) { should eq(600) }
		its(:grid_height) { should eq(10) }
		its(:grid_width) { should eq(10) }

	end
	context "Oponent Board" do
		before{oponent_board_cmd.execute!}
		subject{oponent.board}
		its(:height) { should eq(600) }
		its(:width) { should eq(600) }
		its(:grid_height) { should eq(10) }
		its(:grid_width) { should eq(10) }
	end
end