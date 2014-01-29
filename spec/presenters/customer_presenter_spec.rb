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
end
