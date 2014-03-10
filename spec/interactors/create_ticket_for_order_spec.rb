require "interactor_spec_helper"
require_relative "../../app/interactors/create_ticket_for_order"

describe Interactor::CreateTicketForOrder do
  let(:ticket_gateway) { dummy_gateway }
  let(:order_gateway) { dummy_gateway }
  subject { described_class.new(request) }
  let(:request) { OpenStruct.new(order_id: 24, note: "Er war nicht da!") }
  let(:customer) { OpenStruct.new(full_name: "Max Mann") }
  let(:order) { OpenStruct.new(customer: customer, id: 24) }

  before do
    subject.ticket_gateway = ticket_gateway
    subject.order_gateway = order_gateway

    order_gateway.update order

    subject.run
  end

  it "creates a new ticket" do
    expect(ticket_gateway.fetch.size).to eq 1
  end

  it "includes the customer's name in the title" do
    expect(ticket_gateway.fetch.first.title).to include "Fahrer-Bemerkung"
  end

  it "has the note as the body" do
    expect(ticket_gateway.fetch.first.body).to eq "Er war nicht da!"
  end

  it "knows about the order" do
    expect(ticket_gateway.fetch.first.order).to eq order
  end

  it "knows about the customer" do
    expect(ticket_gateway.fetch.first.customer).to eq customer
  end
end
