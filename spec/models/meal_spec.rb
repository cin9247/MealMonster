require_relative "../../app/models/meal"

describe Meal do
  describe "#attributes=" do
    let(:meal) { Meal.new name: "Spaghetti" }

    it "overwrites existing attributes" do
      meal.attributes = {name: "Hackbraten"}
      expect(meal.name).to eq "Hackbraten"
    end
  end

  describe "#kilojoules=" do
    before do
      subject.kilojoules = kJ
    end

    context "given ' '" do
      let(:kJ) { ' ' }

      it "sets kilojoules to nil" do
        expect(subject.kilojoules).to be_nil
      end
    end

    context "given '32'" do
      let(:kJ) { '32' }

      it "converts it to an integer" do
        expect(subject.kilojoules).to eq 32
      end
    end
  end

  describe "#bread_units=" do
    before do
      subject.bread_units = bu
    end

    context "given ' '" do
      let(:bu) { ' ' }

      it "sets bread_units to nil" do
        expect(subject.bread_units).to be_nil
      end
    end

    context "given '32.2'" do
      let(:bu) { '32.2' }

      it "converts it to a float" do
        expect(subject.bread_units).to eq 32.2
      end
    end
  end

  describe "#persisted?" do
    context "when id exists" do
      it "is persisted" do
        expect(Meal.new(id: 42)).to be_persisted
      end
    end

    context "when id does not exist" do
      it "is not persisted" do
        expect(subject).to_not be_persisted
      end
    end
  end
end
