require "spec_helper"

describe CustomerMapper do
  let(:customer) { Customer.new forename: "Max", surname: "Mustermann" }

  before do
    customer.address = Address.new(town: "Karlsruhe", postal_code: "76131")
  end

  describe "#save" do
    it "saves the customer" do
      subject.save customer
      expect(subject.fetch.size).to eq 1
      expect(subject.fetch.first.forename).to eq "Max"
    end

    it "saves the associated address" do
      subject.save customer

      expect(subject.fetch.first.address.town).to eq "Karlsruhe"
    end
  end

  describe "#update" do
    before do
      subject.save customer
    end

    it "updates the customer" do
      customer.forename = "Peter"
      customer.address.town = "Stuttgart"

      subject.update customer

      expect(subject.fetch.size).to eq 1
      expect(subject.fetch.first.forename).to eq "Peter"
      expect(subject.fetch.first.address.town).to eq "Stuttgart"
    end

    it "saves the address if it's new" do
      customer.address = Address.new(town: "Dresden", postal_code: "12345")

      subject.update customer

      expect(subject.fetch.first.address.town).to eq "Dresden"
    end
  end
end
