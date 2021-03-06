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
    let(:request) { OpenStruct.new(name: "Hackbraten", kilojoules: 1200, bread_units: 1.3) }

    it "adds the meal" do ## how to test this?
      expect(meal_gateway.all.size).to eq 1
      expect(meal_gateway.all.first.name).to eq "Hackbraten"
    end

    it "returns a successful response" do
      expect(response.status).to eq :successfully_created
    end

    it "returns the created object" do
      expect(response.object.name).to eq "Hackbraten"
      expect(response.object.kilojoules).to eq 1200
      expect(response.object.bread_units).to eq 1.3
    end
  end

  describe "invalid request" do
    pending
  end
end
