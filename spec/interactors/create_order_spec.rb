require_relative "../../app/interactors/create_order"
require "interactor_spec_helper"

describe Interactor::CreateOrder do
  let(:customer_gateway) { dummy_gateway }
  let(:offering_gateway) { dummy_gateway }
  let(:order_gateway) { dummy_gateway }

  let(:request) { OpenStruct.new(customer_id: 23, offering_ids: [14, 15], date: Date.new(2013, 9, 1), note: "Mit Eis, bitte!") }

  subject { Interactor::CreateOrder.new(request) }

  before do
    subject.order_gateway = order_gateway
    subject.customer_gateway = customer_gateway
    subject.offering_gateway = offering_gateway
  end

  context "given valid request" do
    before do
      customer_gateway.update OpenStruct.new id: 23, name: "Peter"
      offering_gateway.update OpenStruct.new id: 14, date: Date.new(2013, 9, 1)
      offering_gateway.update OpenStruct.new id: 15, date: Date.new(2013, 9, 1)
    end

    let!(:response) { subject.run }

    it "saves the order" do
      expect(order_gateway.all.size).to eq 1
      expect(order_gateway.all.first.customer.name).to eq "Peter"
      expect(order_gateway.all.first.offerings.size).to eq 2
      expect(order_gateway.all.first.offerings.first.id).to eq 14
      expect(order_gateway.all.first.offerings.last.id).to eq 15
      expect(order_gateway.all.first.note).to eq "Mit Eis, bitte!"
      expect(order_gateway.all.first.date).to eq Date.new(2013, 9, 1)
    end

    it "returns successfully created" do
      expect(response.status).to eq :successfully_created
    end
  end

  context "given non existing customer" do
    pending
  end

  context "given non existing offering" do
    pending
  end
end
