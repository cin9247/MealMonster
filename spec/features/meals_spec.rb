require "spec_helper"
require "ostruct"

describe "meals" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

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
    let(:price_class_1) { PriceClass.new(name: "PK 1") }
    let(:price_class_2) { PriceClass.new(name: "PK 2") }

    before do
      PriceClassMapper.new.save price_class_1
      PriceClassMapper.new.save price_class_2

      visit new_meal_path

      fill_in "Name", with: "Hackbraten mit Schweineblut"
      fill_in "Broteinheiten", with: 2
      fill_in "meal_kilojoules", with: 4153

      select "PK 2", from: "Preisklasse"

      click_on "Gericht erstellen"
    end

    it "creates a new meal for the kitchen" do
      expect(kitchen.meals.length).to eq 1

      first_meal = kitchen.meals.first
      expect(first_meal.name).to eq "Hackbraten mit Schweineblut"
      expect(first_meal.bread_units).to eq 2
      expect(first_meal.kilojoules).to eq 4153
      expect(first_meal.price_class.name).to eq price_class_2.name
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
