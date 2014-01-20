require "interactor_spec_helper"
require_relative "../../app/interactors/list_tours"

describe Interactor::ListTours do
  let(:tour_gateway)  { dummy_gateway }
  let(:order_gateway)  { dummy_gateway }

  before do
    subject.tour_gateway = tour_gateway
    hans = OpenStruct.new name: "Hans"
    peter = OpenStruct.new name: "Peter"
    marie = OpenStruct.new name: "Marie"

    customers = [hans, peter, marie]

    tour_gateway.save OpenStruct.new id: 1, name: "Tour #1", customers: [hans, peter]
    tour_gateway.save OpenStruct.new id: 2, name: "Tour #2", customers: [peter]

    order_gateway.save OpenStruct.new id: 1, customer: hans, date: Date.new(2013, 10, 1)
    order_gateway.save OpenStruct.new id: 1, customer: peter, date: Date.new(2013, 10, 1)
  end

  let(:request) { OpenStruct.new(date: Date.new(2013, 10, 1)) }
  subject { Interactor::ListTours.new(request) }

  let!(:response) { subject.run }

  it "returns all tours for that date" do
    tours = response.object
    expect(tours.size).to eq 2
    expect(tours.first.name).to eq "Tour #1"
  end
end
