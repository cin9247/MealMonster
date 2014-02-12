require "interactor_spec_helper"
require_relative "../../app/interactors/create_tour"

describe Interactor::CreateTour do
  let(:customer_gateway) { dummy_gateway }
  let(:tour_gateway) { dummy_gateway }

  before do
    subject.tour_gateway     = tour_gateway
    subject.customer_gateway = customer_gateway
  end

  let(:request) { OpenStruct.new(name: name, customer_ids: customer_ids) }
  subject { Interactor::CreateTour.new(request) }

  let(:customer_1) { OpenStruct.new id: 1 }
  let(:customer_2) { OpenStruct.new id: 2 }
  before do
    customer_gateway.should_receive(:find).with(customer_ids).and_return [customer_1, customer_2]
  end

  let!(:response) { subject.run }

  describe "valid request" do
    let(:name) { "Lightning McQueen" }
    let(:customer_ids) { [1, 2] }

    it "creates the tour" do
      expect(tour_gateway.all.size).to eq 1
      expect(tour_gateway.all.first.name).to eq "Lightning McQueen"
      expect(tour_gateway.all.first.customers).to include customer_1
      expect(tour_gateway.all.first.customers).to include customer_2
    end

    it "returns successfully created" do
      expect(response.status).to eq :successfully_created
    end
  end

  describe "invalid request" do
    pending
  end
end
