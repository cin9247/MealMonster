require "spec_helper"

describe "tours" do
  let!(:customer_1) { create_customer "Peter", "Mustermann" }
  let!(:customer_2) { create_customer "Dieter", "Heinzelmann" }
  let!(:customer_3) { create_customer "Maria", "Meyer" }

  before do
    login_as_admin_web

    create_tour "Tour #1", []
    create_tour "Tour #2", [customer_3.id, customer_1.id]
    create_tour "Tour #3", []

    create_driver "Max Speed"
    create_driver "Ludwig Limit"

    visit manage_tours_path
  end

  def save_and_reload
    find("button", text: "Speichern").click
    find("div.alert-box", text: "Erfolgreich gespeichert")

    visit manage_tours_path
  end

  describe "manage tours", js: true do
    it "shows all customers in the table and tours" do
      within(".customers") do
        expect(page).to have_content "Peter Mustermann"
        expect(page).to have_content "Dieter Heinzelmann"
      end

      within(".tours") do
        expect(page).to have_content "Maria Meyer"
      end
    end

    describe "adding of customers to tour" do
      it "adds customers to tours" do
        within(".customers") do
          find("tr", text: "Peter Mustermann").click_on "#1"
        end

        within(".customers") do
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
          find(".station", text: "Maria Meyer").find(".remove").click# "Löschen"
        end

        save_and_reload

        within ".tours" do
          expect(page).to_not have_content "Maria Meyer"
        end
      end
    end

    describe "removing tours" do
      it "let's users remove tours" do
        all("li.tour")[2].click_on "Tour löschen"

        save_and_reload

        expect(all("li.tour").length).to eq 2

        within ".tours" do
          expect(page).to have_content "Tour #1"
          expect(page).to have_content "Tour #2"
          expect(page).to_not have_content "Tour #3"
        end
      end
    end

    describe "changing drivers" do
      it "saves the selected driver" do
        within ".tours li", text: "Tour #1" do
          select "Ludwig Limit", from: "Fahrer"
        end

        save_and_reload

        within ".tours li", text: "Tour #1" do
          pending "expectation doesn't work"
          #expect(page).to have_select("Fahrer", selected: "Ludwig Limit")
        end
      end
    end
  end

  describe "list tours" do
    let(:offering) { create_offering(Date.new(2014, 1, 29)) }
    let(:marias_order) { create_order(customer_3.id, offering.id) }
    let(:peters_order) { create_order(customer_1.id, offering.id) }

    before do
      deliver_order(marias_order.id)
      load_order(peters_order.id)

      visit tours_path(from: Date.new(2014, 1, 29), to: Date.new(2014, 2, 3))
    end

    it "displays tags for delivered and loaded" do
      within ".day", text: "Mittwoch, der 29.01.2014" do
        expect(all("li.tour").size).to eq 3
        within ".station", text: "Maria Meyer" do
          expect(page).to have_css("i.delivered")
        end
        within ".station", text: "Peter Mustermann" do
          expect(page).to have_css("i.loaded")
        end
      end
    end
  end

  describe "tour details" do
    let(:date) { Date.new(2015, 1, 29) }

    before do
      offering_1 = create_offering(date, "Spaghetti")
      offering_2 = create_offering(date, "Rabenfutter")

      tour = create_tour "Schnelle Tour", [customer_1.id, customer_2.id, customer_3.id]

      create_order(customer_1.id, offering_1.id)
      create_order(customer_2.id, offering_1.id, offering_2.id)

      visit tour_path(tour, date: date)
    end

    it "displays the tour name" do
      expect(page).to have_css("h1", text: "Schnelle Tour")
    end

    it "displays the current date" do
      expect(page).to have_content "29.01.2015"
    end

    it "lists all customers which have ordered for today" do
      within(".stations") do
        expect(page).to have_content customer_1.surname
        expect(page).to have_content customer_2.surname
        expect(page).to_not have_content customer_3.surname
      end
    end

    it  "contains an overview of all ordered offerings" do
      within ".order-overview" do
        within "tr", text: "Spaghetti" do
          expect(page).to have_content "2"
        end
        within "tr", text: "Rabenfutter" do
          expect(page).to have_content "1"
        end
      end
    end

  end
end
