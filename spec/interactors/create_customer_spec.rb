require_relative "../../app/interactors/create_customer"
require "interactor_spec_helper"

describe Interactor::CreateCustomer do
  let(:customer_gateway) { dummy_gateway }
  let(:customer_source) { ->(args) { OpenStruct.new(args.merge(valid?: valid)) } }

  let(:subject) { Interactor::CreateCustomer.new(request) }

  let(:krankenhaus) { OpenStruct.new(id: 1, name: "Krankenhaus") }
  let(:altenheim) { OpenStruct.new(id: 2, name: "Altenheim") }

  before do
    subject.customer_gateway = customer_gateway
    subject.customer_source = customer_source
  end

  let!(:response) { subject.run }

  describe "valid request" do
    let(:valid) { true }
    let(:request) { OpenStruct.new(forename: "Peter", surname: "Mustermann", prefix: "Herr") }

    it "adds the customer" do ## how to test this?
      expect(customer_gateway.all.size).to eq 1
      expect(customer_gateway.all.first.forename).to eq "Peter"
      expect(customer_gateway.all.first.prefix).to eq "Herr"
    end

    it "returns a successful response" do
      expect(response.status).to eq :successfully_created
    end
  end

  describe "invalid request" do
    let(:valid) { false }
    let(:request) { OpenStruct.new(forename: "Peter", surname: "") }

    it "returns an error response" do
      expect(response.status).to eq :invalid_request
    end
  end
end
