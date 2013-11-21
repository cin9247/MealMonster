require "interactor_spec_helper"
require_relative "../../app/interactors/add_address_to_customer"

describe Interactor::AddAddressToCustomer do
  context "valid request" do
    let(:address_source) { ->(args) { OpenStruct.new(args) } }
    let(:customer_gateway) { dummy_gateway }
    let(:customer_id) { customer_gateway.save(OpenStruct.new) }
    subject { Interactor::AddAddressToCustomer.new(customer_id, "Heinestr.", "43", "74123", "München") }

    before do
      subject.address_source = address_source
      subject.customer_gateway = customer_gateway
    end

    it "adds the address to the customer" do
      subject.run
      customer = customer_gateway.find customer_id
      expect(customer.address.street_name).to eq "Heinestr."
      expect(customer.address.street_number).to eq "43"
      expect(customer.address.postal_code).to eq "74123"
      expect(customer.address.town).to eq "München"
    end
  end
end