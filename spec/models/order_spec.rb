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
end
