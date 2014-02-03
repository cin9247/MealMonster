require_relative "../../app/helpers/application_helper"

describe ApplicationHelper do
  let(:helper) { Object.new.extend(described_class) }

  describe "#money" do
    let(:result) { helper.money(price) }

    context "price given" do
      let(:price) { double(:price, amount: 3015, currency: "EUR") }

      it "returns the price formatted and in euros" do
        expect(result).to eq "30,15 €"
      end
    end

    context "no price given" do
      let(:price) { nil }

      it "returns '-,--'" do
        expect(result).to eq "-,--"
      end
    end
  end
end
