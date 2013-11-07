require "spec_helper"

describe "offerings" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let!(:hackbraten) { create_meal kitchen, name: "Hackbraten" }
  let!(:spaghetti)  { create_meal kitchen, name: "Spaghetti" }
  let!(:nusskuchen) { create_meal kitchen, name: "Nusskuchen" }

  describe "viewing the offerings" do
    before do
      m_1 = kitchen.new_menu meals: [hackbraten, spaghetti]
      m_2 = kitchen.new_menu meals: [hackbraten, nusskuchen]
      m_3 = kitchen.new_menu meals: [nusskuchen]

      organization.day("2013-05-06").offer! m_1
      organization.day("2013-05-06").offer! m_2
      organization.day("2013-05-07").offer! m_3

      visit "/offerings?from=2013-05-04&to=2013-05-08"
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

  describe "creating a menu", js: true do
    it "" do
      visit new_offering_path(from: "2013-10-12", to: "2013-10-12")

      first_menu = all("li.menu")[0]
      second_menu = all("li.menu")[1]

      within(first_menu) do
        expect(page).to have_content "Menu #1"
      end

      spaghetti = find("ul.meals li", text: "Spaghetti")
      hackbraten = find("ul.meals li", text: "Hackbraten")

      spaghetti.drag_to first_menu
      hackbraten.drag_to second_menu

      within(first_menu) do
        expect(page).to have_content "Spaghetti"
      end

      within(second_menu) do
        expect(page).to have_content "Hackbraten"
      end

      click_on "Submit"

      visit offerings_path(from: "2013-10-12", to: "2013-10-12")

      within(".day", text: "12.10.2013") do
        within("li", text: "Menu #1") do
          expect(page).to have_content "Spaghetti"
        end
        within("li", text: "Menu #2") do
          expect(page).to have_content "Hackbraten"
        end
      end
    end
  end
end
