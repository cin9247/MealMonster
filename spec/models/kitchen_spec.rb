require_relative "../../app/models/kitchen"
require "ostruct"

describe Kitchen do

  let(:meal_mapper) {
    double :meal_mapper, fetch: [],
                         save: nil,
                         clean: nil,
                         find: nil
  }

  before do
    subject.meal_mapper = meal_mapper
  end

  describe "initialization" do
    it "doesn't know how to cook any meals" do
      expect(subject.meals).to eq []
    end
  end

  describe "#new_meal" do
    before do
      subject.meal_source = ->(kitchen = nil, options = {}) { OpenStruct.new(options.merge(kitchen: kitchen)) }
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
      meal_mapper.should_receive(:save).with(meal)
      subject.add_meal meal
    end
  end

  describe "#new_menu" do
    before do
      subject.menu_source = ->(kitchen = nil, options = {}) { OpenStruct.new(options.merge kitchen: kitchen) }
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
      subject.add_menu menu
      expect(subject.menus).to eq [menu]
    end
  end

  describe "#menu_for_day" do
    before do
      ## TODO return menu when adding it
      @m_1 = double(:menu, date: Date.new(2013, 4, 5))
      @m_2 = double(:menu, date: Date.new(2013, 7, 5))
      @m_3 = double(:menu, date: Date.new(2013, 6, 5))
      subject.add_menu @m_1
      subject.add_menu @m_2
      subject.add_menu @m_3
    end

    let(:result) { subject.menu_for_day(date) }

    context "given a date with no menu" do
      let(:date) { Date.new(2012, 5, 6) }

      it "returns nil" do
        expect(result).to be_nil
      end
    end

    context "given a date to which a menu exists" do
      let(:date) { Date.new(2013, 7, 5) }

      it "returns the associated menu" do
        expect(result).to eq @m_2
      end
    end
  end

  describe "#clean_up!" do
    it "removes all meals" do
      meal_mapper.should_receive(:clean)
      subject.clean_up!
    end

    it "removes all menus" do
      subject.add_menu double(:menu)
      subject.clean_up!
      expect(subject.menus).to be_empty
    end
  end

  describe "#find_meal_by_id" do
    context "given an integer id" do
      it "asks the meal mapper" do
        meal_mapper.should_receive(:find).with(4)
        subject.find_meal_by_id(4)
      end
    end

    context "given a string id" do
      it "asks the meal mapper" do
        meal_mapper.should_receive(:find).with(4)
        subject.find_meal_by_id("4")
      end
    end
  end

end
