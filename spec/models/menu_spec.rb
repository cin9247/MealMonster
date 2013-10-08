require_relative "../../app/models/menu"

describe Menu do
  describe "#meals" do
    it "initially has no meals" do
      expect(subject.meals).to eq []
    end
  end

  describe "initialization" do
    let(:meals) { [double(:meal), double(:meal)] }
    let(:subject) { Menu.new meals: meals }

    it "saves meals on initialization" do
      expect(subject.meals).to eq meals
    end
  end

  describe "#offer!" do
    let(:kitchen) { double(:kitchen) }

    before do
      subject.kitchen = kitchen
    end

    it "adds the menu to the kitchen" do
      kitchen.should_receive(:add_menu).with(subject)
      subject.offer!
    end
  end

  describe "#meal_ids" do
    before do
      subject.meals = [double(:meal, id: 2), double(:meal, id: 5)]
    end

    it "returns the ids of all meals" do
      expect(subject.meal_ids).to eq [2, 5]
    end
  end

  describe "#persisted?" do
    context "when id exists" do
      it "is persisted" do
        expect(Menu.new(id: 42)).to be_persisted
      end
    end

    context "when id does not exist" do
      it "is not persisted" do
        expect(subject).to_not be_persisted
      end
    end
  end
end
