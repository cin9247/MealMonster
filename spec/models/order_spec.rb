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
end
