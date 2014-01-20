require_relative "../../app/interactors/update_customer"
require "interactor_spec_helper"

describe Interactor::UpdateCustomer do
  let(:customer_gateway) { dummy_gateway }
  let(:customer) { OpenStruct.new(forename: "Max", surname: "Musterfrau")}
  let(:customer_id) { customer_gateway.save customer }
  let(:request) { OpenStruct.new(customer_id: customer_id, forename: "Peter", surname: "Mustermann") }
  let(:subject) { Interactor::UpdateCustomer.new(request) }

  before do
    subject.customer_gateway = customer_gateway
  end

  let!(:response) { subject.run }

  describe "valid request" do
    it "updates the customer" do
      expect(customer_gateway.all.size).to eq 1
      expect(customer_gateway.all.first.forename).to eq "Peter"
    end
  end

  describe "invalid request" do
    pending "TODO"
  end
end
