require 'spec_helper'

describe Game::GameCmd do
	let(:name) { "Jack" }
	let(:email) { "jack@mail.com" }

	let(:cmd) { Game::GameCmd.new(name, email) }

	let(:result) { {"id"=>1, "x"=>1, "y"=>1} }

	before do
		DatabaseCleaner.clean
		
		#{}"http://battle.platform45.com/register"
		stub_request(:post, "http://localhost:3001/api/battleship/register").
         with(:body => "{\"name\":\"Jack\",\"email\":\"jack@mail.com\"}",
              :headers => {'Content-Type'=>'application/json'}).
         to_return(:status => 200, 
         					 :body => { id:1, x:1, y:1 }.to_json, 
         					 :headers => {'Content-Type'=>'application/json'})
	end

	context "Battleship Response" do
		before{cmd.execute!}

		it "Should have valid response" do
			cmd.game_result.parsed_response.should eq(result)
		end

		context "Game Returned" do
			subject{cmd.game}
			its(:id){ should eq(1)}
			its(:battleship_id){ should eq(1)}
			its(:name){ should eq("Jack")}
			its(:email){ should eq("jack@mail.com")}
			its(:game_status){ should eq("busy")}
			its(:prize){ should be_nil}
		end
	end
end