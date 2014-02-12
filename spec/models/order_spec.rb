require_relative "../../app/models/order"

describe Order do
  describe "#deliver!" do
    it "sets the state to delivered" do
      subject.deliver!
      expect(subject.delivered?).to eq true
      expect(subject.loaded?).to eq false
    end
  end

  describe "#load!" do
    it "sets the state to loaded" do
      subject.load!
      expect(subject.loaded?).to eq true
      expect(subject.delivered?).to eq false
    end
  end

  describe "after initialization" do
    it "is not delivered" do
      expect(subject.delivered?).to eq false
    end
  end

  describe "#price" do
    let(:result) { Order.new(offerings: offerings).price }

    context "no offerings for this order" do
      let(:offerings) { [] }

      it "returns zero" do
        expect(result).to eq Money.zero
      end
    end

    context "two offerings given" do
      let(:offerings) { [double(:offering, price: Money.new(12)), double(:offering, price: Money.new(2))] }

      it "sums up the price" do
        expect(result).to eq Money.new(14)
      end
    end
  end
end
