require "interactor_spec_helper"
require_relative "../../app/interactors/load"
require_relative "../../app/models/order"

describe Interactor::Load do
  let(:subject) { Interactor::Load.new(order_id) }
  let(:order_gateway) { dummy_gateway }
  let(:order) { Order.new }
  let(:order_id) { order_gateway.save order }

  before do
    subject.order_gateway = order_gateway
  end

  it "sets the order to loaded" do
    subject.run

    order = order_gateway.find order_id

    expect(order).to be_loaded
    expect(order).to_not be_delivered
  end
end
