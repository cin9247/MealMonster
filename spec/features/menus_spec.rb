require "spec_helper"

describe "menus" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let!(:hackbraten) { create_meal kitchen, name: "Hackbraten" }
  let!(:spaghetti)  { create_meal kitchen, name: "Spaghetti" }
  let!(:nusskuchen) { create_meal kitchen, name: "Nusskuchen" }

  describe "viewing the menus" do
    before do
      m_1 = kitchen.new_menu meals: [hackbraten, spaghetti]
      m_2 = kitchen.new_menu meals: [hackbraten, nusskuchen]
      m_3 = kitchen.new_menu meals: [nusskuchen]

      kitchen.day("2013-05-06").offer! m_1
      kitchen.day("2013-05-06").offer! m_2
      kitchen.day("2013-05-07").offer! m_3

      visit "/menus?date=2013-05-04..2013-05-08"
    end

    it "displays a list of menus for each day" do
      within(".day", text: "06.05.2013") do
        within("li", text: "Menu #1") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Spaghetti"
        end

        within("li", text: "Menu #2") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Nusskuchen"
        end
      end

      within(".day", text: "07.05.2013") do
        within("li", text: "Menu #1") do
          expect(page).to have_content "Nusskuchen"
          expect(page).to_not have_content "Spaghetti"
          expect(page).to_not have_content "Hackbraten"
        end
      end
    end
  end

  describe "creating a menu for a day" do
    before do
      visit new_menu_path

      fill_in "Date", with: "2013-10-03"

      select "Hackbraten", from: "Meals"
      select "Nusskuchen", from: "Meals"

      click_on "Menu erstellen"
    end

    let(:date) { Date.new(2013, 10, 3) }
    let(:menu) { kitchen.menus.first }

    xit "creates a menu with the selected meals" do
      expect(kitchen.menus.length).to eq 1
      expect(menu.meals.length).to eq 2
      expect(menu.meals.first.name).to eq "Hackbraten"
      expect(menu.meals.first.name).to eq "Hackbraten"
    end
  end
end
