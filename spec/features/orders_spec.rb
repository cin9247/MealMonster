# encoding: utf-8

require "spec_helper"

describe "orders" do
  before do
    login_as_admin_web
  end

  let(:names) { %w(Max Peter Johanna) }

  let(:meal_1) { create_meal "Spaghetti" }
  let(:meal_2) { create_meal "Braten" }

  let(:date) { Date.new(2013, 10, 5) }
  let(:another_date) { Date.new(2013, 10, 6) }

  let!(:offering_1) { create_offering(date, "Veggie-Menu", [meal_1].map(&:id)) }
  let!(:offering_2) { create_offering(date, "Für Pfundskerle", [meal_2].map(&:id)) }
  let!(:offering_3) { create_offering(another_date, "Für Pfundskerle", [meal_2].map(&:id)) }

  describe "displaying orders" do
    describe "by day" do
      before do
        customers = names.map do |name|
          create_customer(name, "lastname")
        end

        create_order(customers[0].id, offering_1.id)
        create_order(customers[1].id, offering_2.id)
        create_order(customers[2].id, offering_3.id)

        visit orders_path(:from => "2013-10-05", :to => "2013-10-06")
      end

      it "shows the current date" do
        expect(page).to have_content "05.10.2013"
      end

      it "lists all names of the people who ordered a menu" do
        within(".day", text: "05.10.2013") do
          expect(page).to have_content "Max"
          expect(page).to have_content "Peter"
          expect(page).to_not have_content "Johanna"

          expect(page).to have_content "Veggie-Menu"
          expect(page).to have_content "Für Pfundskerle"
        end

        within(".day", text: "06.10.2013") do
          expect(page).to_not have_content "Max"
          expect(page).to_not have_content "Peter"
          expect(page).to have_content "Johanna"

          expect(page).to_not have_content "Veggie-Menu"
          expect(page).to have_content "Für Pfundskerle"
        end
      end
    end
  end

  describe "displaying orders grouped by catchment area" do
    before do
      c_1 = create_catchment_area("C1")
      c_2 = create_catchment_area("C2")
      c_3 = create_catchment_area("C3")

      customer_1 = create_customer "Peter"
      customer_2 = create_customer "Dieter"
      customer_3 = create_customer "Hans"

      set_catchment_area_of_customer customer_1.id, c_1.id
      set_catchment_area_of_customer customer_2.id, c_1.id
      set_catchment_area_of_customer customer_3.id, c_2.id

      create_order customer_1.id, offering_1.id
      create_order customer_2.id, offering_1.id
      create_order customer_3.id, offering_1.id

      visit by_catchment_area_orders_path(date: date)
    end

    it "lists all catchment areas with orders" do
      expect(page).to have_css("h2", text: "C1")
      expect(page).to have_css("h2", text: "C2")
      expect(page).to_not have_content "C3"
    end

    it "groups the orders by offering for each catchment area" do
      within("li", text: "C1") do
        expect(page).to have_content "Veggie-Menu"
        expect(page).to have_content "2"
      end
    end
  end

  describe "creating order" do
    before do
      create_user "admin", "admin", "admin"
      login_with "admin", "admin"
      create_customer "Max", "Mustermann"
    end

    before do
      visit new_order_path(:from => "2013-10-05", to: "2013-10-05")

      select "Mustermann, Max", from: "Kunde"
      select "Veggie-Menu", from: "Bestellung 1"
      select "Für Pfundskerle", from: "Bestellung 2"

      click_on "Bestellungen aufgeben"
    end

    it "redirects to orders_path" do
      expect(current_path).to eq orders_path
      expect(page).to have_content "5.10.2013"
    end

    it "should have created the order" do
      orders = OrderMapper.new.fetch
      order = orders.first

      expect(orders.length).to eq 1
      expect(orders.first.offerings.length).to eq 2
      expect(order.date).to eq Date.new(2013, 10, 5)
      expect(order.offerings.first.menu.name).to eq "Veggie-Menu"
      expect(order.offerings.last.menu.name).to eq "Für Pfundskerle"
    end
  end
end
