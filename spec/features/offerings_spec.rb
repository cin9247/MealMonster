require "spec_helper"

describe "offerings" do
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

      organization.day("2013-05-06").offer! m_1
      organization.day("2013-05-06").offer! m_2
      organization.day("2013-05-07").offer! m_3

      visit "/offerings?date=2013-05-04..2013-05-08"
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
end
