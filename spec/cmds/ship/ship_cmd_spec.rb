require 'spec_helper'

describe Ship::ShipCmd do
	before{DatabaseCleaner.clean}
	let!(:player) { FactoryGirl.create(:player) }
	let!(:oponent) { FactoryGirl.create(:oponent) }

	let(:player_cmd) { Ship::ShipCmd.new(player) }
	let(:oponent_cmd) { Ship::ShipCmd.new(oponent) }


	context "Create random ships" do
		before{player_cmd.execute!}

		it "should create ships" do
			player.ships.count.should eq(7)
		end
	end
	context "Create Empty ships" do
		before{oponent_cmd.execute_empty!}
		
		it "Should create empty ships" do
			oponent.ships.count.should eq(7)
		end
		it "Should update ship" do
			oponent_cmd.update_ship!("Carrier", "Sunk", 5, 7, "vertical")
			ship = oponent.ships.where{(name == "Carrier") & (status == "Sunk")}.first
			
			ship.location_x.should eq(5)
			ship.location_y.should eq(7) 
		end
	end
end