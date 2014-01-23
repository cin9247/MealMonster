require "interactor_spec_helper"
require_relative "../../app/interactors/link_user_to_customer"

describe Interactor::LinkUserToCustomer do
  let(:user_gateway) { dummy_gateway }
  let(:customer_gateway) { dummy_gateway }
  let(:user) { OpenStruct.new }
  let(:customer) { OpenStruct.new(forename: "Peter") }
  let(:user_id) { user_gateway.save user }
  let(:customer_id) { customer_gateway.save customer }
  let(:request) { OpenStruct.new customer_id: customer_id, user_id: user_id }
  let(:subject) { Interactor::LinkUserToCustomer.new(request) }

  before do
    subject.user_gateway = user_gateway
    subject.customer_gateway = customer_gateway

    subject.run
  end

  it "mu" do
    expect(user_gateway.fetch.first.customer.forename).to eq "Peter"
  end
end
