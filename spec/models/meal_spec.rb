require_relative "../../app/models/meal"

describe Meal do
  describe "initialization" do
    it "starts with blank attributes" do
      expect(subject.name).to be_nil
    end

    it "grabs the name from attributes hash" do
      m = Meal.new nil, name: "Schnitzel"
      expect(m.name).to eq "Schnitzel"
    end

    it "saves the kitchen instance" do
      kitchen = double(:kitchen)
      m = Meal.new kitchen
      expect(m.kitchen).to eq kitchen
    end
  end

  describe "#attributes=" do
    let(:meal) { Meal.new nil, name: "Spaghetti" }

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
        expect(Meal.new(nil, id: 42)).to be_persisted
      end
    end

    context "when id does not exist" do
      it "is not persisted" do
        expect(subject).to_not be_persisted
      end
    end
  end
end
