require "spec_helper"
require "ostruct"

describe "meals" do
  describe "listing of meals kitchen" do
    let(:meal_1) { KITCHEN.new_meal name: "Hackbraten mit Pommes Frites" }
    let(:meal_2) { KITCHEN.new_meal name: "Spaghetti Bolognese" }

    before do
      meal_1.offer!
      meal_2.offer!

      visit meals_path
    end

    after do
      KITCHEN.clean_up!
    end

    it "shows Hackbraten and Spaghetti" do
      within ".meals" do
        expect(page).to have_content "Spaghetti Bolognese"
        expect(page).to have_content "Hackbraten mit Pommes Frites"
      end
    end
  end

  describe "creation of new meals" do
    before do
      visit "/meals/new"

      fill_in "Name", with: "Hackbraten mit Schweineblut"

      click_on "Create Meal"
    end

    it "creates a new meal for the kitchen" do
      expect(KITCHEN.meals.length).to eq 1
      expect(KITCHEN.meals.first.name).to eq "Hackbraten mit Schweineblut"
    end
  end
end
