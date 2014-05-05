require 'spec_helper'

describe GameController do

	it "should render index" do
	  get :index
	  expect(response).to render_template("index")
	end

	context "Start Game" do
		it "Should call new game method" do
			Game::GameCmd.any_instance.expects(:execute!).once
			Player::PlayerCmd.any_instance.expects(:execute!).once
			Oponent::OponentCmd.any_instance.expects(:execute!).once
			Nuke::NukeCmd.expects(:new).twice
			get :start_game
			expect(response).to render_template("start_game")
		end
	end

end