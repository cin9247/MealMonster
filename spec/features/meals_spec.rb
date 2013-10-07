require "spec_helper"
require "ostruct"

describe "meals" do
  let(:kitchen) { Kitchen.new }

  describe "listing of meals kitchen" do
    let(:meal_1) { kitchen.new_meal name: "Hackbraten mit Pommes Frites" }
    let(:meal_2) { kitchen.new_meal name: "Spaghetti Bolognese" }

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

  describe "creation of new meals" do
    before do
      visit new_meal_path

      fill_in "Name", with: "Hackbraten mit Schweineblut"

      click_on "Gericht erstellen"
    end

    it "creates a new meal for the kitchen" do
      expect(kitchen.meals.length).to eq 1
      expect(kitchen.meals.first.name).to eq "Hackbraten mit Schweineblut"
    end
  end

  describe "editing of existing meals" do
    before do
      meal = kitchen.new_meal name: "Hackbraten"
      meal.offer!

      visit edit_meal_path(meal)

      fill_in "Name", with: "Spaghetti"

      click_on "Gericht aktualisieren"
    end

    it "overwrites the existing meal with the new name" do
      expect(kitchen.meals.length).to eq 1
      expect(kitchen.meals.first.name).to eq "Spaghetti"
    end
  end
end
