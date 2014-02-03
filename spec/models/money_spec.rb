require_relative "../../app/models/money"

describe Money do
  describe ".parse" do
    let(:result) { described_class.parse(input) }

    context "given '10,32 €'" do
      let(:input) { '10,32 €' }

      it "sets the currency to EUR" do
        expect(result.currency).to eq "EUR"
      end

      it "sets the amount to 1032" do
        expect(result.amount).to eq 1032
      end
    end

    context "given '10,32'" do
      let(:input) { '10,32' }

      it "sets the amount to 1032" do
        expect(result.amount).to eq 1032
      end
    end

    context "given '10.32'" do
      let(:input) { '10.32' }

      it "sets the amount to 1032" do
        expect(result.amount).to eq 1032
      end
    end

    context "given '  10, 32 €€'" do
      let(:input) { '  10, 32 €€' }

      it "sets the amount to 1032" do
        expect(result.amount).to eq 1032
      end
    end

    context "given '  102 €€'" do
      let(:input) { '  102 €€' }

      it "sets the amount to 10200" do
        expect(result.amount).to eq 10200
      end
    end

    context "given '10,2€'" do
      let(:input) { '10,2€' }

      it "sets the amount to 1020" do
        expect(result.amount).to eq 1020
      end
    end

    context "given '10,200€'" do
      let(:input) { '10,200€' }

      it "sets the amount to 1020" do
        expect(result.amount).to eq 1020
      end
    end
  end
end
