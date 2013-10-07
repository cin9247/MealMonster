require_relative "../../app/models/offering"

describe Offering do
  describe "attributes" do
    describe "#date" do
      let(:day) { double(:day, date: Date.new(2013, 4, 6)) }

      before do
        subject.day = day
      end

      it "knows its date by asking the associated day" do
        expect(subject.date).to eq Date.new(2013, 4, 6)
      end

      it "can overwrite that information" do
        subject.date = Date.new(2013, 4, 7)
        expect(subject.date).to eq Date.new(2013, 4, 7)
      end
    end
  end
end
