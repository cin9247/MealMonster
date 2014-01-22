require "spec_helper"

describe OrderMapper do
  let(:organization) { Organization.new }
  let(:meal_1) { Meal.new name: "Hack" }
  let(:meal_2) { Meal.new name: "Karotte" }
  let(:menu_1) { Menu.new name: "Menu #1", meals: [meal_1, meal_2] }
  let(:menu_2) { Menu.new name: "Menu #2", meals: [meal_1] }
  let(:offering_1) { organization.day("2013-10-06").new_offering menu: menu_1 }
  let(:offering_2) { organization.day("2013-10-07").new_offering menu: menu_2 }
  let(:customer) { organization.new_customer forename: "Hans" }
  let(:other_customer) { organization.new_customer forename: "Peter" }
  let(:order_1) { Order.new offering: offering_1, customer: customer }
  let(:order_2) { Order.new offering: offering_2, customer: customer }
  let(:order_3) { Order.new offering: offering_2, customer: other_customer }

  before do
    MenuMapper.new.save menu_1
    MenuMapper.new.save menu_2
    CustomerMapper.new.save customer
    CustomerMapper.new.save other_customer
    OfferingMapper.new.save offering_1
    OfferingMapper.new.save offering_2
  end

  describe "#fetch" do
    before do
      subject.save order_1
    end

    let(:result) { subject.fetch }

    it "fetches all offerings" do
      expect(result.size).to eq 1
    end

    it "fetches the menu for the offering" do
      expect(result.first.menu.name).to eq "Menu #1"
    end

    it "fetches each meal for the offered menu" do
      expect(result.first.menu.meals.size).to eq 2
      expect(result.first.menu.meals.map(&:name).sort).to eq ["Hack", "Karotte"]
    end

    it "sets the day" do
      expect(result.first.date).to eq Date.new(2013, 10, 6)
    end
  end

  describe "#find_by_date" do
    before do
      subject.save order_1
      subject.save order_2
    end

    it "returns only the orders for that date" do
      result = subject.find_by_date Date.new(2013, 10, 7)
      expect(result.size).to eq 1
      expect(result.first.customer.forename).to eq "Hans"
    end
  end

  describe "#find_by_customer_id" do
    before do
      subject.save order_1
      subject.save order_2
      subject.save order_3
    end

    let(:result) { subject.find_by_customer_id(customer.id) }

    it "b" do
      expect(result.size).to eq 2
      expect(result.map(&:customer).map(&:forename)).to eq ["Hans", "Hans"]
    end
  end
end
