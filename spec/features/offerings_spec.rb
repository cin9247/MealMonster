require "spec_helper"

describe "offerings" do
  let!(:hackbraten) { create_meal "Hackbraten" }
  let!(:spaghetti)  { create_meal "Spaghetti" }
  let!(:nusskuchen) { create_meal "Nusskuchen" }

  before do
    login_as_admin_web
  end

  describe "viewing the offerings" do
    before do
      create_offering(Date.new(2013, 5, 6), "Menü #1", [hackbraten, spaghetti].map(&:id))
      create_offering(Date.new(2013, 5, 6), "Menü #2", [hackbraten, nusskuchen].map(&:id))
      create_offering(Date.new(2013, 5, 7), "Menü #1", [nusskuchen].map(&:id))

      visit "/offerings?from=2013-05-04&to=2013-05-08"
    end

    it "displays a list of menus for each day" do
      within(".day", text: "06.05.2013") do
        within("li", text: "Menü #1") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Spaghetti"
        end

        within("li", text: "Menü #2") do
          expect(page).to have_content "Hackbraten"
          expect(page).to have_content "Nusskuchen"
        end
      end

      within(".day", text: "07.05.2013") do
        within("li", text: "Menü #1") do
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

      spaghetti = find("ul.meals li", text: "Spaghetti")
      hackbraten = find("ul.meals li", text: "Hackbraten")

      spaghetti.drag_to first_menu
      hackbraten.drag_to second_menu

      within(first_menu) do
        fill_in "Name", with: "Feinkost-Menü"
        expect(page).to have_content "Spaghetti"
      end

      within(second_menu) do
        fill_in "Name", with: "Magerkost-Menü"
        expect(page).to have_content "Hackbraten"
      end

      click_on "Submit"

      visit offerings_path(from: "2013-10-12", to: "2013-10-12")

      within(".day", text: "12.10.2013") do
        within("li", text: "Feinkost-Menü") do
          expect(page).to have_content "Spaghetti"
        end
        within("li", text: "Magerkost-Menü") do
          expect(page).to have_content "Hackbraten"
        end
      end
    end
  end
end
