require "interactor_spec_helper"
require_relative "../../app/interactors/create_tour"

describe Interactor::CreateTour do
  let(:customer_gateway) { dummy_gateway }
  let(:tour_gateway) { dummy_gateway }

  before do
    subject.tour_gateway     = tour_gateway
    subject.customer_gateway = customer_gateway
    subject.tour_source      = tour_source
  end

  subject { Interactor::CreateTour.new(name, customer_ids) }

  let!(:response) { subject.run }

  describe "valid request" do
    before do
      customer_gateway.save OpenStruct.new id: 1
      customer_gateway.save OpenStruct.new id: 2
    end
    let(:name) { "Lightning McQueen" }
    let(:customer_ids) { [1, 2] }
    let(:tour_source) { ->(args) { OpenStruct.new(args.merge(valid?: true)) } }

    it "creates the tour" do
      expect(tour_gateway.all.size).to eq 1
    end

    it "returns successfully created" do
      expect(response.status).to eq :successfully_created
    end
  end

  describe "invalid request" do
    let(:tour_source) { ->(args) { OpenStruct.new(args.merge(valid?: false)) } }
    let(:name) { "Tour #1" }
    let(:customer_ids) { [] }

    it "returns invalid request" do
      expect(response.status).to eq :invalid_request
    end

    it "doesn't add any tours" do
      expect(tour_gateway.all).to eq []
    end
  end
end
