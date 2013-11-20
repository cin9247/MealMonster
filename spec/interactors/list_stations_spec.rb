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
  let(:order_1) { OpenStruct.new id: 1, customer: customer_1, date: date }
  let(:order_2) { OpenStruct.new id: 2, customer: customer_2, date: Date.new(2013, 10, 6) }
  let(:order_3) { OpenStruct.new id: 3, customer: customer_3, date: date }

  before do
    customers = [customer_1, customer_2]

    tour_gateway.update OpenStruct.new id: tour_id, name: "Tour", customers: customers
    order_gateway.update order_1
    order_gateway.update order_2
    order_gateway.update order_3
    subject.tour_gateway = tour_gateway
    subject.order_gateway = order_gateway
  end

  subject { Interactor::ListStations.new(tour_id, date) }

  let(:result) { subject.run }

  it "returns a list of stations for that day" do
    expect(result.object.length).to eq 1
    expect(result.object.first.customer).to eq customer_1
    expect(result.object.first.order).to eq order_1
  end
end
