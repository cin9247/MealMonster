require "spec_helper"
require "ostruct"

describe "meals" do
  describe "lists all available meals of kitchen" do
    let(:meal_1) { KITCHEN.new_meal name: "Hackbraten mit Pommes Frites" }
    let(:meal_2) { KITCHEN.new_meal name: "Spaghetti Bolognese" }

    before do
      meal_1.offer!
      meal_2.offer!

      visit meals_path
    end

    it "shows Hackbraten and Spaghetti" do
      within ".meals" do
        expect(page).to have_content "Spaghetti Bolognese"
        expect(page).to have_content "Hackbraten mit Pommes Frites"
      end
    end
  end
end
