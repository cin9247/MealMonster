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
end
