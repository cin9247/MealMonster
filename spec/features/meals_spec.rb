require "spec_helper"
require "ostruct"

describe "meals" do
  before do
    login_as_admin_web
  end

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

    it "creates a new meal" do
      meals = MealMapper.new.fetch
      expect(meals.length).to eq 1
      expect(meals.first.name).to eq "Hackbraten mit Schweineblut"
      expect(meals.first.bread_units).to eq 2
      expect(meals.first.kilojoules).to eq 4153
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
      meals = MealMapper.new.fetch
      expect(meals.length).to eq 1
      expect(meals.first.name).to eq "Spaghetti"
    end
  end
end
