require 'spec_helper'

describe Oponent::OponentCmd do
	before do
		DatabaseCleaner.clean
	end

	let(:game) { FactoryGirl.create(:game) }

	let(:cmd) { Oponent::OponentCmd.new(game) }

	context "Create Oponent " do
		before do
			cmd.stubs(:new_oponent_board).returns true
			cmd.execute!
		end
		subject{game.oponent}

		its(:id) { should eq(1) }

	end
end