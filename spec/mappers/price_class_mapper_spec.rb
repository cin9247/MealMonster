require "spec_helper"

describe PriceClassMapper do
  let(:price_class) { PriceClass.new price: Money.new(3104, 'EUR'), name: "PK 1" }

  describe "#save" do
    before do
      subject.save price_class
    end

    it "persists the name" do
      expect(subject.fetch.size).to eq 1

      expect(subject.fetch.first.name).to eq "PK 1"
    end

    it "persists the price" do
      expect(subject.fetch.first.price).to eq Money.new(3104, 'EUR')
    end
  end
end
