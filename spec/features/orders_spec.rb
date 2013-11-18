# encoding: utf-8

require "spec_helper"

describe "orders" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }
  let(:names) { %w(Max Peter Johanna) }

  let(:meal_1) { kitchen.new_meal name: "Spaghetti" }
  let(:meal_2) { kitchen.new_meal name: "Braten" }

  let(:menu_1) { kitchen.new_menu meals: [meal_1], name: "Veggie-Menu" }
  let(:menu_2) { kitchen.new_menu meals: [meal_2], name: "Für Pfundskerle" }

  let(:date) { Date.parse "2013-10-05" }
  let(:another_date) { Date.parse "2013-10-06" }

  let!(:offering_1) { organization.day(date).offer! menu_1 }
  let!(:offering_2) { organization.day(date).offer! menu_2 }
  let!(:offering_3) { organization.day(another_date).offer! menu_2 }

  describe "displaying orders" do
    describe "by day" do
      before do
        customers = names.map do |name|
          create_customer(name, "lastname")
        end

        order = organization.day(date).new_order customer: customers[0], offering: offering_1
        order.place!

        order = organization.day(date).new_order customer: customers[1], offering: offering_2
        order.place!

        order = organization.day(another_date).new_order customer: customers[2], offering: offering_3
        order.place!

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
      create_customer "Max", "Mustermann"
    end

    before do
      visit new_order_path(:date => "2013-10-05")

      select "Max Mustermann", from: "Kunden"
      select "Veggie-Menu", from: "Menu"

      click_on "Bestellung erstellen"
    end

    it "should have created the order" do
      expect(organization.orders.length).to eq 1
      expect(organization.orders.first.day.date).to eq Date.new(2013, 10, 5)
      expect(organization.orders.first.menu.name).to eq "Veggie-Menu"
    end
  end
end
