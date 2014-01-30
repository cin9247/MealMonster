require_relative "../../app/models/tour"

describe Tour do
  describe "#customers" do
    it "defaults to an empty array" do
      expect(Tour.new.customers).to eq []
    end
  end

  describe "#eject_driver!" do
    subject { Tour.new driver: double(:driver) }

    before { subject.eject_driver! }

    it "removes the driver" do
      expect(subject.driver).to be_nil
    end
  end
end
