require_relative "../../app/interactors/create_customer"
require 'ostruct'

describe Interactor::CreateCustomer do
  let(:customer_gateway) do
    Class.new do
      def all
        items
      end

      def save item
        items << item
      end

      private
        def items
          @items ||= []
        end
    end.new
  end

  let(:subject) { Interactor::CreateCustomer.new(request) }

  before do
    subject.customer_gateway = customer_gateway
  end

  let!(:response) { subject.run }

  describe "valid request" do
    let(:request) { OpenStruct.new(forename: "Peter", surname: "Mustermann", valid?: true) }

    it "adds the customer" do ## how to test this?
      expect(customer_gateway.all.size).to eq 1
      expect(customer_gateway.all.first.forename).to eq "Peter"
    end

    it "returns a successful response" do
      expect(response.status).to eq :successfully_created
    end
  end

  describe "invalid request" do
    let(:request) { OpenStruct.new(surname: "Mustermann", valid?: false) }

    it "returns an error response" do
      expect(response.status).to eq :invalid_request
    end
  end
end
