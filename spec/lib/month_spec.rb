require "month"

describe Month do
  describe "#next" do
    context "given month in the middle of the year" do
      it "returns the next month" do
        month = Month.new(2014, 6)
        expect(month.next.year).to eq 2014
        expect(month.next.month).to eq 7
      end
    end

    context "given month at the end of a year" do
      it "returns the next month in the new year" do
        month = Month.new(2014, 12)
        expect(month.next.year).to eq 2015
        expect(month.next.month).to eq 1
      end
    end
  end

  describe "#previous" do
    context "given month in the middle of the year" do
      it "returns the previous month" do
        month = Month.new(2014, 6)
        expect(month.previous.year).to eq 2014
        expect(month.previous.month).to eq 5
      end
    end

    context "given month at the beginning of a year" do
      it "returns the previous month in the new year" do
        month = Month.new(2014, 1)
        expect(month.previous.year).to eq 2013
        expect(month.previous.month).to eq 12
      end
    end
  end
end
