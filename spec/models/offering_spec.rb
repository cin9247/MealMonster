require_relative "../../app/models/offering"

describe Offering do
  describe "attributes" do
    let(:day) { double(:day, date: Date.new(2013, 4, 6)) }

    before do
      subject.day = day
    end

    it "can save the day it belongs to" do
      subject.day = day
      expect(subject.day).to eq day
    end

    describe "#date" do
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
