require_relative "../../app/presenters/customer_presenter"
require "ostruct"

describe CustomerPresenter do
  let(:customer) { OpenStruct.new }
  subject { CustomerPresenter.new(customer) }

  describe "#short_address" do
    context "address given" do
      before do
        address = double(:address,
                         street_name: "Heinestr.",
                         street_number: "4",
                         postal_code: "76131",
                         town: "Karlsruhe")
        customer.address = address
      end

      it "displays just the town and street" do
        expect(subject.short_address).to eq "Heinestr. 4, Karlsruhe"
      end
    end

    context "no address given" do
      before do
        customer.address = nil
      end

      it "returns an empty string" do
        expect(subject.short_address).to eq ""
      end
    end
  end

  describe "#catchment_area_name" do
    let(:catchment_area) { double(name: "Krankenhaus") }

    before do
      customer.catchment_area = catchment_area
    end

    it "returns the name" do
      expect(subject.catchment_area_name).to eq "Krankenhaus"
    end

    context "given no catchment area" do
      let(:catchment_area) { nil }

      it "returns '(Keines)'" do
        expect(subject.catchment_area_name).to eq "(Keines)"
      end
    end
  end

  describe "#date_of_birth" do
    before do
      customer.date_of_birth = date_of_birth
    end

    context "given no date of birth" do
      let(:date_of_birth) { nil }

      it "returns ''" do
        expect(subject.date_of_birth).to eq ""
      end
    end

    context "given valid date" do
      let(:date_of_birth) { Date.new(1983, 10, 2) }

      it "returns '2.10.1983'" do
        expect(subject.date_of_birth).to eq "2.10.1983"
      end
    end
  end
end
