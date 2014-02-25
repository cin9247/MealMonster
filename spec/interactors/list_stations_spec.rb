require "interactor_spec_helper"
require_relative "../../app/interactors/list_stations"

describe Interactor::ListStations do
  let(:tour_gateway) { dummy_gateway }
  let(:order_gateway) { dummy_gateway }
  let(:tour_id) { 1 }
  let(:date) { Date.new(2013, 10, 5) }
  let(:customer_1) { double(:customer, id: 1) }
  let(:customer_2) { double(:customer, id: 2) }
  let(:customer_3) { double(:customer, id: 3) }
  let(:order_1) { OpenStruct.new id: 1, customer: customer_2, date: date }
  let(:order_2) { OpenStruct.new id: 2, customer: customer_1, date: Date.new(2013, 10, 6) }

  before do
    customers = [customer_1, customer_2]

    tour = OpenStruct.new id: tour_id, name: "Tour", customers: customers

    tour_gateway.update tour
    subject.tour_gateway = tour_gateway
    subject.order_gateway = order_gateway
    expect(order_gateway).to receive(:fetch_by_date_and_tour).with(date, tour_id).and_return [order_1, order_2]
    expect(tour_gateway).to receive(:find_sparse).with(tour_id).and_return tour
  end

  let(:request) { OpenStruct.new(tour_id: tour_id, date: date) }
  subject { Interactor::ListStations.new(request) }

  let(:result) { subject.run }

  it "returns a list of stations for that day" do
    expect(result.object.stations.length).to eq 2
    expect(result.object.stations.first.customer).to eq customer_2
    expect(result.object.stations.first.order).to eq order_1
  end

  it "returns the name of the tour" do
    expect(result.object.name).to eq "Tour"
  end

  it "returns the date" do
    expect(result.object.date).to eq date
  end
end
