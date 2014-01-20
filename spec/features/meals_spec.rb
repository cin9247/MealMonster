require "spec_helper"
require "ostruct"

describe "meals" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  describe "listing of meals kitchen" do
    before do
      create_meal "Hackbraten mit Pommes Frites"
      create_meal "Spaghetti Bolognese"

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
      fill_in "Broteinheiten", with: 2
      fill_in "meal_kilojoules", with: 4153

      click_on "Gericht erstellen"
    end

    it "creates a new meal for the kitchen" do
      expect(kitchen.meals.length).to eq 1
      expect(kitchen.meals.first.name).to eq "Hackbraten mit Schweineblut"
      expect(kitchen.meals.first.bread_units).to eq 2
      expect(kitchen.meals.first.kilojoules).to eq 4153
    end
  end

  describe "editing of existing meals" do
    before do
      meal = create_meal "Hackbraten"

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
