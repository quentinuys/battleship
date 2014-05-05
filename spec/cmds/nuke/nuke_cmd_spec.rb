require 'spec_helper'

describe Nuke::NukeCmd do

	before{DatabaseCleaner.clean}

	let(:game) { FactoryGirl.create(:game) }
	
	let(:player) { FactoryGirl.create(:player, game: game) }
	let(:oponent) { FactoryGirl.create(:oponent, game: game) }

	let(:player_cmd) { Nuke::NukeCmd.new(player, oponent) }
	let(:oponent_cmd) { Nuke::NukeCmd.new(oponent, player) }

	let(:player_ship_cmd) { Ship::ShipCmd.new(player) }
	let(:oponent_ship_cmd) { Ship::ShipCmd.new(oponent) }

	before do
		Board::BaseBoardCmd.new(player).execute!
		Board::BaseBoardCmd.new(oponent).execute!


	end

	context "Fire Nuke" do
		context "Fire Hit" do
			before	do
				oponent_ship_cmd.execute_empty!
				#"http://battle.platform45.com/nuke"
				stub_request(:post, "http://localhost:3001/api/battleship/nuke").
         to_return(:status => 200, 
         					 :body => { id:1, x:4, y:4, status: "hit", sunk: nil, game_status: nil, error: nil, prize: nil }.to_json, 
         					 :headers => {'Content-Type'=>'application/json'})
				player_cmd.fire_clever_nuke!
			end

			it "Should have hit response" do
				player_cmd.hit_response.should eq({"id"=>1, "x"=>4, "y"=>4, "status"=>"hit", "sunk"=>nil, "game_status"=>nil, "error"=>nil, "prize"=>nil})
			end

			it "Should update nuke" do
				player.nukes.last.status.should eq("hit")
			end
		end
		context "Fire Miss" do
			before	do
				oponent_ship_cmd.execute_empty!
				stub_request(:post, "http://localhost:3001/api/battleship/nuke").
         to_return(:status => 200, 
         					 :body => { id:1, x:4, y:4, status: "miss", sunk: nil, game_status: nil, error: nil, prize: nil }.to_json, 
         					 :headers => {'Content-Type'=>'application/json'})
				player_cmd.fire_clever_nuke!
			end
			it "Should have miss response" do
				player_cmd.hit_response.should eq({"id"=>1, "x"=>4, "y"=>4, "status"=>"miss", "sunk"=>nil, "game_status"=>nil, "error"=>nil, "prize"=>nil})
			end

			it "Should update nuke" do
				player.nukes.last.status.should eq("miss")
			end
		end
	end

	context "Receive Nuke" do
		before do 
			player_ship_cmd.execute!
			oponent_ship_cmd.execute_empty!
			ship = player.ships.first
			ship.update_attributes!(location_x:5, location_y:6, direction:"vertical")
		end

		context "Receive Hit" do
			before do
				oponent_cmd.fire_nuke!(5, 6)
			end
			it "Should have hit response" do
				oponent_cmd.hit_response.should eq({"id"=>nil, "x"=>nil, "y"=>nil, "status"=>"hit", "sunk"=>nil, "game_status"=>nil, "error"=>nil, "prize"=>nil})
			end			
		end

		context "Sink Ship" do
			before do
				oponent.nukes.create(x_position: 5, y_position: 7, status: "hit" )
				oponent.nukes.create(x_position: 5, y_position: 8, status: "hit" )
				oponent.nukes.create(x_position: 5, y_position: 9, status: "hit" )
				oponent.nukes.create(x_position: 5, y_position: 10, status: "hit" )
				oponent_cmd.fire_nuke!(5, 6)
			end
			it "Should sink ship" do
				oponent_cmd.hit_response.should eq({"id"=>nil, "x"=>nil, "y"=>nil, "status"=>"hit", "sunk"=>"Carrier", "game_status"=>nil, "error"=>nil, "prize"=>nil})
			end
		end

		context "Receive Miss" do
			before do
				oponent_cmd.stubs(:ship_hit).returns(nil)
				oponent_cmd.fire_nuke!(6, 8)
			end
			it "Should have hit response" do
				oponent_cmd.hit_response.should eq({"id"=>nil, "x"=>nil, "y"=>nil, "status"=>"miss", "sunk"=>nil, "game_status"=>nil, "error"=>nil, "prize"=>nil})
			end			
		end
	end
end