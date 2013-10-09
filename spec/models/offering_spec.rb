require_relative "../../app/models/offering"

describe Offering do
  describe "attributes" do
    describe "#date" do
      before do
        subject.day = day
      end

      context "when day exists" do
        let(:day) { double(:day, date: Date.new(2013, 4, 6)) }

        it "knows its date by asking the associated day" do
          expect(subject.date).to eq Date.new(2013, 4, 6)
        end
      end

      context "when day doesn't exist" do
        let(:day) { double(:day, date: nil) }

        it "returns nil" do
          expect(subject.date).to be_nil
        end
      end
    end
  end
end
