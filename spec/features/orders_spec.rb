require "spec_helper"

describe "orders" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }
  let(:names) { %w(Max Peter Johanna) }

  describe "displaying orders" do
    describe "by day" do
      let(:date) { Date.parse "2013-10-05" }

      before do
        customers = names.map do |name|
          organization.new_customer(forename: name).tap do |c|
            c.subscribe!
          end
        end

        meal_1 = kitchen.new_meal name: "Spaghetti"
        meal_2 = kitchen.new_meal name: "Braten"

        menu_1 = kitchen.new_menu meals: [meal_1]
        menu_2 = kitchen.new_menu meals: [meal_2]
        organization.day(date).offer! menu_1
        organization.day(date).offer! menu_2

        order = organization.day(date).new_order customer: customers[0], menu: menu_1
        order.place!

        order = organization.day(date).new_order customer: customers[1], menu: menu_2
        order.place!

        visit orders_path(:date => "2013-10-05")
      end

      it "shows the current date" do
        expect(page).to have_content "05.10.2013"
      end

      it "lists all names of the people who ordered a menu" do
        expect(page).to have_content "Max"
        expect(page).to have_content "Peter"
        expect(page).to_not have_content "Johanna"
      end
    end
  end
end