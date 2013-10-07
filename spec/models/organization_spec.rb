require_relative "../../app/models/organization"
require "ostruct"

describe Organization do
  let(:customer_mapper) { double(:customer_mapper) }

  before do
    subject.customer_mapper = customer_mapper
  end

  describe "#customers" do
    it "asks customer_mapper for customers" do
      result = double(:result)
      customer_mapper.should_receive(:fetch).and_return(result)
      expect(subject.customers).to eq result
    end
  end

  describe "#new_customer" do
    before do
      subject.customer_source = ->(options={}) { OpenStruct.new(options) }
    end

    it "creates a new instance and passes arguments through" do
      expect(subject.new_customer(forename: "Peter").forename).to eq "Peter"
    end

    it "sets the organization" do
      expect(subject.new_customer.organization).to eq subject
    end
  end

  describe "#add_customer" do
    let(:customer) { double(:customer) }

    it "saves the customer using the customer_mapper" do
      customer_mapper.should_receive(:save).with customer
      subject.add_customer customer
    end
  end
end
