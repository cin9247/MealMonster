require_relative "../../app/interactors/create_order"
require "interactor_spec_helper"

describe Interactor::CreateOrder do
  let(:customer_gateway) { dummy_gateway }
  let(:offering_gateway) { dummy_gateway }
  let(:order_gateway) { dummy_gateway }

  subject { Interactor::CreateOrder.new(23, 14, "Mit Eis, bitte!") }

  before do
    subject.order_gateway = order_gateway
    subject.customer_gateway = customer_gateway
    subject.offering_gateway = offering_gateway
    subject.order_source = order_source
  end

  context "given valid request" do
    let(:order_source) { ->(args) { OpenStruct.new(args.merge(:valid? => true)) }}

    before do
      customer_gateway.update OpenStruct.new id: 23, name: "Peter"
      offering_gateway.update OpenStruct.new id: 14
    end

    let!(:response) { subject.run("actor-id") }

    it "saves the order" do
      expect(order_gateway.all.size).to eq 1
      expect(order_gateway.all.first.customer.name).to eq "Peter"
      expect(order_gateway.all.first.offering.id).to eq 14
      expect(order_gateway.all.first.note).to eq "Mit Eis, bitte!"
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
