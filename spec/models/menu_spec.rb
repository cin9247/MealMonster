require_relative "../../app/models/menu"

describe Menu do
  describe "#meals" do
    it "initially has no meals" do
      expect(subject.meals).to eq []
    end
  end

  describe "initialization" do
    let(:kitchen) { double(:kitchen) }
    let(:meals) { [double(:meal), double(:meal)] }
    let(:subject) { Menu.new kitchen, meals: meals }

    it "saves meals on initialization" do
      expect(subject.meals).to eq meals
    end

    it "saves the kitchen instance" do
      expect(subject.kitchen).to eq kitchen
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

  describe "#meal_ids=" do
    let(:meal_1) { double(:meal, id: 3) }
    let(:meal_2) { double(:meal, id: 6) }

    let(:meals) { [meal_1, meal_2] }
    let(:kitchen) { double(:kitchen, meals: meals) }

    it "sets the meals according to the ids and known meals in kitchen" do
      subject.kitchen = kitchen
      subject.meal_ids = ["6"]
      expect(subject.meals).to eq [meal_2]
    end
  end
end
