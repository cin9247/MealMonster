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

  describe "#find_menu_by_id" do
    let(:menu) { OpenStruct.new }

    context "given an integer id" do
      it "asks the menu mapper for integer id" do
        menu_mapper.should_receive(:find).with(4).and_return(menu)
        expect(subject.find_menu_by_id(4)).to eq menu
      end
    end

    context "given a string id" do
      it "asks the menu mapper for integer id" do
        menu_mapper.should_receive(:find).with(4).and_return(menu)
        expect(subject.find_menu_by_id("4")).to eq menu
      end
    end

    context "given a non existing id" do
      it "returns nil" do
        menu_mapper.should_receive(:find).and_return nil
        expect(subject.find_menu_by_id(6)).to be_nil
      end
    end

    it "sets the kitchen of the result to self" do
      menu_mapper.should_receive(:find).and_return(menu)
      subject.find_menu_by_id(4)
      expect(menu.kitchen).to eq subject
    end
  end

end
