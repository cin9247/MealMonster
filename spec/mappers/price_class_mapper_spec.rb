require "spec_helper"

describe PriceClassMapper do
  let(:price) { PriceClass.new name: "PK1" }

  describe "#save" do
    it "saves the price class" do
      subject.save price
      expect(subject.fetch.size).to eq 1
      expect(subject.fetch.first.name).to eq "PK1"
    end
  end

  describe "#find" do
    it "finds the price" do
      subject.save price
      expect(subject.find(price.id).name).to eq price.name
    end
  end
end
