require "spec_helper"

describe TourMapper do
  let(:tour) { Tour.new name: "Tour #1", customers: [customer_1, customer_2] }
  let(:customer_1) { Customer.new forename: "Peter" }
  let(:customer_2) { Customer.new forename: "Dieter" }

  before do
    CustomerMapper.new.save customer_1
    CustomerMapper.new.save customer_2
  end

  describe "#save" do
    before do
      subject.save tour
    end

    let(:result) { subject.fetch }

    it "saves the tour" do
      expect(result.first.name).to eq "Tour #1"
    end

    it "saves the customers" do
      expect(result.first.customers.size).to eq 2
      expect(result.first.customers.first.forename).to eq "Peter"
    end

    it "orders the customer properly"
  end
end
