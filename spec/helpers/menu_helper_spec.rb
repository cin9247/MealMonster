require_relative "../../app/helpers/menu_helper"

describe MenuHelper do
  let(:helper) { Object.new.extend(MenuHelper) }

  describe "#meal_list" do
    let(:meal_1) { double(:meal, name: "Spagehtti") }
    let(:meal_2) { double(:meal, name: "Rote Beete") }
    let(:menu) { double(:menu, meals: [meal_1, meal_2]) }

    it "returns the meals of a menu as comma seperated list" do
      expect(helper.meal_list(menu)).to eq "Spagehtti, Rote Beete"
    end
  end

  describe "#menu_list" do
    let(:menu_1) { double(:menu, name: "Menu #1") }
    let(:menu_2) { double(:menu, name: "Vegetarische Köstlichkeiten") }
    let(:offering_1) { double(:offering, menu: menu_1) }
    let(:offering_2) { double(:offering, menu: menu_2) }
    let(:order) { double(:order, offerings: [offering_1, offering_2])}

    ## TODO remove test pain
    it "returns the menu names of an order" do
      expect(helper.menu_list(order)).to eq "Menu #1, Vegetarische Köstlichkeiten"
    end
  end
end
