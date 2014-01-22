# encoding: utf-8

require "spec_helper"

describe "orders" do
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

        visit orders_path(:date => "2013-10-05")
      end

      it "shows the current date" do
        expect(page).to have_content "05.10.2013"
      end

      it "lists all names of the people who ordered a menu" do
        within(".day", text: "05.10.2013") do
          expect(page).to have_content "Max"
          expect(page).to have_content "Peter"
          expect(page).to_not have_content "Johanna"

          expect(page).to have_content "Spaghetti"
          expect(page).to have_content "Braten"
        end

        within(".day", text: "06.10.2013") do
          expect(page).to_not have_content "Max"
          expect(page).to_not have_content "Peter"
          expect(page).to have_content "Johanna"

          expect(page).to_not have_content "Spaghetti"
          expect(page).to have_content "Braten"
        end
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
      visit new_order_path(:date => "2013-10-05")

      select "Max Mustermann", from: "Kunden"
      select "Veggie-Menu", from: "Menu"

      click_on "Bestellung erstellen"
    end

    it "should have created the order" do
      orders = OrderMapper.new.fetch
      expect(orders.length).to eq 1
      expect(orders.first.day.date).to eq Date.new(2013, 10, 5)
      expect(orders.first.menu.name).to eq "Veggie-Menu"
    end
  end
end
