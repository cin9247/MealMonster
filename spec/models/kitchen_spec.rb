require_relative "../../app/models/kitchen"
require "ostruct"

describe Kitchen do

  describe "initialization" do
    it "has doesn't know how to cook any meals" do
      expect(subject.meals).to eq []
    end
  end

  describe "#new_meal" do
    before do
      subject.meal_source = ->(options = {}) { OpenStruct.new(options) }
    end

    it "sets the meal's kitchen reference to itself" do
      expect(subject.new_meal.kitchen).to eq subject
    end

    it "passes attributes through" do
      expect(subject.new_meal(name: "Pommes").name).to eq("Pommes")
    end
  end

  describe "#add_meal" do
    let(:meal) { double(:meal) }

    it "adds the meal" do
      subject.add_meal meal
      expect(subject.meals).to eq [meal]
    end
  end

  describe "#clean_up!" do
    before do
      subject.add_meal double(:meal)
      subject.clean_up!
    end

    it "removes all meals" do
      expect(subject.meals).to be_empty
    end
  end

end
