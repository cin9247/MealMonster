require_relative "../../app/models/tour"

describe Tour do
  describe "#customers" do
    it "defaults to an empty array" do
      expect(Tour.new.customers).to eq []
    end
  end
end
