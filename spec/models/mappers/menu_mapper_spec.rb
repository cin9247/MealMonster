require "spec_helper"

describe MenuMapper do
  describe "#save" do
    let(:meal_1) { Meal.new(name: "Hackbraten") }
    let(:meal_2) { Meal.new(name: "Schweinebraten") }
    let(:menu) { Menu.new(meals: [meal_1, meal_2]) }

    before do
      subject.save menu
    end

    it "creates the meal objects" do
      expect(subject.fetch.first.meals.length).to eq 2
      expect(subject.fetch.first.meals.first.name).to eq "Hackbraten"
    end
  end

  describe "#find" do
    let(:meal) { Meal.new name: "Hacksteak" }

    before do
      @id_1 = subject.save Menu.new(meals: [meal])
      @id_2 = subject.save Menu.new(meals: [meal])
    end

    let(:result) { subject.find id }

    context "given unexisting id" do
      let(:id) { 0 }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "given existing id" do
      let(:id) { @id_2 }

      it "returns meal instance" do
        expect(result.meals.first.name).to eq "Hacksteak"
      end

      it "sets id of meal instance" do
        expect(result.meals.first.id).to_not be_nil
      end
    end
  end
end
