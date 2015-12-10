require 'spec_helper'

describe GameController do

	it "should render index" do
	  get :index
	  expect(response).to render_template("index")
	end

	context "Start Game" do
	end

end