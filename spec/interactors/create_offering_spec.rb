require_relative "../../app/interactors/create_offering"
require "interactor_spec_helper"

describe Interactor::CreateOffering do
  let(:offering_gateway) { dummy_gateway }
  let(:meal_gateway) { dummy_gateway }
  let(:offering_source) { ->(args) { OpenStruct.new(args.merge(valid?: true)) } }

  before do
    subject.offering_gateway = offering_gateway
    subject.meal_gateway = meal_gateway
    subject.offering_source = offering_source

    meal_gateway.update double(:meal, id: 2)
    meal_gateway.update double(:meal, id: 5)
  end

  let(:request) { OpenStruct.new(name: name, date: date, meal_ids: meal_ids) }

  subject { Interactor::CreateOffering.new(request) }

  context "given valid input" do
    let(:name) { "Menu" }
    let(:meal_ids) { [2, 5] }
    let(:date) { Date.new(2013, 5, 6) }

    let!(:result) { subject.run }

    it "returns the created offering" do
      expect(result.object.date).to eq date
      expect(result.object.menu.name).to eq name
      expect(result.object.menu.meals.length).to eq 2
      expect(result.object.menu.meals.last.id).to eq 5
    end

    it "saves the offering" do
      expect(offering_gateway.all.length).to eq 1
      expect(offering_gateway.all.first.date).to eq date
    end
  end
end
