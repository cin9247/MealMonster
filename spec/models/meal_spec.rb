require_relative "../../app/models/meal"

describe Meal do
  describe "initialization" do
    it "starts with blank attributes" do
      expect(subject.name).to be_nil
    end

    it "grabs the name from attributes hash" do
      m = Meal.new name: "Schnitzel"
      expect(m.name).to eq "Schnitzel"
    end

    it "ignores attributes it doesn't understand" do
      expect(Meal.new(foo_bar: "d", name: "Schnitzel").name).to eq "Schnitzel"
    end
  end

  describe "#attributes=" do
    let(:meal) { Meal.new name: "Spaghetti" }

    it "overwrites existing attributes" do
      meal.attributes = {name: "Hackbraten"}
      expect(meal.name).to eq "Hackbraten"
    end
  end

  describe "#offer!" do
    let(:kitchen) { double(:kitchen) }

    before do
      subject.kitchen = kitchen
    end

    it "adds itself to the kitchen meals" do
      kitchen.should_receive(:add_meal).with(subject)
      subject.offer!
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
