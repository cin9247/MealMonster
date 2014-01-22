require "spec_helper"

describe "tours" do
  def save_and_reload
    find("button", text: "Speichern").click
    find("div.alert-box", text: "Successfully saved")

    visit manage_tours_path
  end

  describe "manage tours", js: true do
    before do
      create_customer "Peter", "Mustermann"
      create_customer "Dieter", "Heinzelmann"
      maria = create_customer "Maria", "Mustermann"

      create_tour "Tour #1", []
      create_tour "Tour #2", [maria.id]
      create_tour "Tour #3", []

      visit manage_tours_path
    end

    it "shows all customers in the table and tours" do
      within("table.customers") do
        expect(page).to have_content "Peter Mustermann"
        expect(page).to have_content "Dieter Heinzelmann"
      end

      within(".tours") do
        expect(page).to have_content "Maria Mustermann"
      end
    end

    describe "adding of customers to tour" do
      it "adds customers to tours" do
        within("table.customers") do
          find("tr", text: "Peter Mustermann").click_on "#1"
        end

        within("table.customers") do
          find("tr", text: "Dieter Heinzelmann").click_on "#3"
        end

        save_and_reload

        tours = page.all(".tours > li")

        expect(tours.first).to have_content "Peter Mustermann"
        expect(tours.last).to have_content "Dieter Heinzelmann"
      end
    end

    describe "removing of customers" do
      it "let's users remove customers from tours" do
        within ".tours" do
          find("li.tour", text: "Maria Mustermann").click_on "X"
        end

        save_and_reload

        within ".tours" do
          expect(page).to_not have_content "Maria Mustermann"
        end
      end
    end
  end
end
