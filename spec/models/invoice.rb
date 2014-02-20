require_relative "../../app/models/invoice"

describe Invoice do
  describe "#total_price" do
    context "given no line items" do
      it "returns 0" do
        expect(subject.total_price).to eq Money.zero
      end
    end

    context "given no line items" do
      it "returns the sum of all line items" do
        subject.line_items = [double(price: Money.new(12)), double(price: Money.new(14))]

        expect(subject.total_price).to eq Money.new(26)
      end
    end
  end
end
