require "spec_helper"

describe "menus" do
  let!(:hackbraten) { create_meal KITCHEN, name: "Hackbraten" }
  let!(:spaghetti) { create_meal KITCHEN, name: "Spaghetti" }
  let!(:nusskuchen) { create_meal KITCHEN, name: "Nusskuchen" }

  after do
    KITCHEN.clean_up!
  end

  describe "viewing the menus" do
    before do
      m_1 = KITCHEN.new_menu meals: [hackbraten, spaghetti], date: Date.new(2013, 5, 6)
      m_2 = KITCHEN.new_menu meals: [hackbraten, nusskuchen], date: Date.new(2013, 5, 6)
      m_1.offer!
      m_2.offer!
      visit menus_path
    end

    it "displays a list of meals for each day" do
      ## TODO be more precise
      within(".menus") do
        expect(page).to have_content "2013-05-06"
        expect(page).to have_content "Hackbraten"
        expect(page).to have_content "Spaghetti"
      end
    end
  end

  describe "creating a menu for a day" do
    before do
      visit new_menu_path

      fill_in "Date", with: "2013-10-03"

      select "Hackbraten", from: "Meals"
      select "Nusskuchen", from: "Meals"

      click_on "Create Menu"
    end

    let(:date) { Date.new(2013, 10, 3) }
    let(:menu) { KITCHEN.menus.first }

    it "creates a menu with the selected meals" do
      expect(KITCHEN.menus.length).to eq 1
      expect(menu.meals.length).to eq 2
      expect(menu.meals.first.name).to eq "Hackbraten"
      expect(menu.meals.first.name).to eq "Hackbraten"
    end
  end
end