require_relative "../../app/models/order"

describe Order do
  describe "#place!" do
    let(:day) { double(:day) }

    it "places an order at its associated day" do
      subject.day = day
      day.should_receive(:add_order).with(subject)
      subject.place!
    end
  end

  describe "#deliver!" do
    it "sets the state to delivered" do
      subject.deliver!
      expect(subject.delivered?).to eq true
    end
  end

  describe "after initialization" do
    it "is not delivered" do
      expect(subject.delivered?).to eq false
    end
  end
end
