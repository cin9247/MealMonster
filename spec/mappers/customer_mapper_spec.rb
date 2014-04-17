require "spec_helper"

describe CustomerMapper do
  let(:customer) { Customer.new forename: "Max", surname: "Mustermann", telephone_number: "179", note: "Notiz", date_of_birth: Date.new(1938, 1, 1), email: "foo@bar.com" }

  before do
    customer.address = Address.new(town: "Karlsruhe", postal_code: "76131")
  end

  describe "#save" do
    it "saves the customer" do
      subject.save customer
      expect(subject.fetch.size).to eq 1
      expect(subject.fetch.first.forename).to eq "Max"
      expect(subject.fetch.first.telephone_number).to eq "179"
      expect(subject.fetch.first.note).to eq "Notiz"
      expect(subject.fetch.first.date_of_birth).to eq Date.new(1938, 1, 1)
      expect(subject.fetch.first.email).to eq "foo@bar.com"
    end

    it "saves the associated address" do
      subject.save customer

      expect(subject.fetch.first.address.town).to eq "Karlsruhe"
    end

    it "retrieves the associated address when using find" do
      subject.save customer

      expect(subject.find(customer.id).address.town).to eq "Karlsruhe"
    end

    it "only updates the address if the customer shares the address" do
      subject.save customer

      new_customer = Customer.new forename: "Peter", address: customer.address

      subject.save new_customer
      expect(subject.fetch.first.address.town).to eq "Karlsruhe"
    end

    describe "catchment area" do
      let(:catchment_area) { CatchmentArea.new(name: "Krankenhaus") }

      before do
        CatchmentAreaMapper.new.save catchment_area
        customer.catchment_area = catchment_area
        subject.save customer
      end

      it "saves the link" do
        expect(subject.find(customer.id).catchment_area.name).to eq "Krankenhaus"
      end
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

  describe "#delete" do
    let(:tour) { Tour.new name: "Tour #1", customers: [customer] }

    before do
      subject.save customer

      TourMapper.new.save tour

      subject.delete customer
    end

    it "removes the customer from all customers" do
      expect(subject.fetch.size).to eq 0
    end

    it "removes the customer from the tour" do
      expect(TourMapper.new.find(tour.id).customers).to eq []
    end
  end
end
