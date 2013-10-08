require_relative "../../app/models/kitchen"
require "ostruct"

describe Kitchen do

  let(:generic_mapper) {
    double :generic_mapper, fetch: [],
                            save: nil,
                            find: nil
  }
  let(:meal_mapper) { generic_mapper }
  let(:menu_mapper) { generic_mapper }

  before do
    subject.meal_mapper = meal_mapper
    subject.menu_mapper = menu_mapper
  end

  describe "#day" do
    before do
      subject.day_source = ->(args = {}) { OpenStruct.new(args) }
    end

    it "returns an object which knows about its date" do
      expect(subject.day("2013-10-03").date).to eq Date.new(2013, 10, 3)
    end

    it "accepts date objects as well" do
      expect(subject.day(Date.new(2013, 10, 3)).date).to eq Date.new(2013, 10, 3)
    end

    it "returns an object which knows about the kitchen" do
      expect(subject.day("2013-10-03").kitchen).to eq subject
    end
  end

  describe "#days" do
    before do
      subject.day_source = ->(args = {}) { OpenStruct.new(args) }
    end

    it "returns an array of days" do
      days = subject.days(Date.new(2013, 10, 3)..Date.new(2013, 10, 7))
      expect(days.length).to eq 5
      expect(days.map(&:date)).to eq [
        Date.new(2013, 10, 3),
        Date.new(2013, 10, 4),
        Date.new(2013, 10, 5),
        Date.new(2013, 10, 6),
        Date.new(2013, 10, 7),
      ]
      expect(days.first.kitchen).to eq subject
    end

    xit "it also accepts strings"
  end

  describe "#meals" do
    it "asks the mapper for all meals" do
      result = double(:result)
      meal_mapper.should_receive(:fetch).and_return(result)
      expect(subject.meals).to eq result
    end
  end

  describe "#menus" do
    it "asks the mapper for all menus" do
      result = double(:result)
      menu_mapper.should_receive(:fetch).and_return(result)
      expect(subject.menus).to eq result
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
    let(:meal) { double(:meal, persisted?: persisted) }

    context "given new meal" do
      let(:persisted) { false }

      it "adds the meal" do
        meal_mapper.should_receive(:save).with(meal)
        subject.add_meal meal
      end
    end

    context "given persisted meal" do
      let(:persisted) { true }

      it "adds the meal" do
        meal_mapper.should_receive(:update).with(meal)
        subject.add_meal meal
      end
    end
  end

  describe "#new_menu" do
    before do
      subject.menu_source = ->(options = {}) { OpenStruct.new(options) }
    end

    it "sets the menu's kitchen reference to itself" do
      expect(subject.new_menu.kitchen).to eq subject
    end

    it "passes attributes through" do
      expect(subject.new_menu(meals: ["meal 1"]).meals).to eq ["meal 1"]
    end
  end

  describe "#add_menu" do
    let(:menu) { double(:menu) }

    it "adds the menu" do
      menu_mapper.should_receive(:save).with(menu)
      subject.add_menu menu
    end
  end

  describe "#find_meal_by_id" do
    let(:meal) { OpenStruct.new }

    context "given an integer id" do
      it "asks the meal mapper for integer id" do
        meal_mapper.should_receive(:find).with(4).and_return(meal)
        expect(subject.find_meal_by_id(4)).to eq meal
      end
    end

    context "given a string id" do
      it "asks the meal mapper for integer id" do
        meal_mapper.should_receive(:find).with(4).and_return(meal)
        expect(subject.find_meal_by_id("4")).to eq meal
      end
    end

    context "given a non existing id" do
      it "returns nil" do
        meal_mapper.should_receive(:find).and_return nil
        expect(subject.find_meal_by_id(6)).to be_nil
      end
    end

    it "sets the kitchen of the result to self" do
      meal_mapper.should_receive(:find).and_return(meal)
      subject.find_meal_by_id(4)
      expect(meal.kitchen).to eq subject
    end
  end

end
