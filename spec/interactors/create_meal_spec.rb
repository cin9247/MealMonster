require_relative "../../app/interactors/create_meal"
require "interactor_spec_helper"

describe Interactor::CreateMeal do
  let(:meal_gateway) { dummy_gateway }

  let(:subject) { Interactor::CreateMeal.new(request) }

  before do
    subject.meal_gateway = meal_gateway
  end

  let!(:response) { subject.run }

  describe "valid request" do
    let(:request) { OpenStruct.new(name: "Hackbraten", valid?: true) }

    it "adds the meal" do ## how to test this?
      expect(meal_gateway.all.size).to eq 1
      expect(meal_gateway.all.first.name).to eq "Hackbraten"
    end

    it "returns a successful response" do
      expect(response.status).to eq :successfully_created
    end
  end

  describe "invalid request" do
    let(:request) { OpenStruct.new(valid?: false) }

    it "returns an error response" do
      expect(response.status).to eq :invalid_request
    end
  end
end
