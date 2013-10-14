require "spec_helper"

describe OrderMapper do
  describe "#fetch" do
    let(:organization) { Organization.new }
    let(:kitchen) { organization.kitchen }
    let(:meal_1) { kitchen.new_meal name: "Hack" }
    let(:meal_2) { kitchen.new_meal name: "Karotte" }
    let(:menu) { kitchen.new_menu name: "menu #2", meals: [meal_1, meal_2] }
    let(:offering) { organization.day("2013-10-06").new_offering menu: menu }
    let(:customer) { organization.new_customer forename: "Hans" }
    let(:order) { Order.new offering: offering, customer: customer, day: Day.new(date: Date.new(2013, 10, 4)) }

    before do
      menu.offer!
      customer.subscribe!
      OfferingMapper.new.save offering
      subject.save order
    end

    let(:result) { subject.fetch }

    it "fetches all offerings" do
      expect(result.size).to eq 1
    end

    it "fetches the menu for the offering" do
      expect(result.first.menu.name).to eq "menu #2"
    end

    it "fetches each meal for the offered menu" do
      expect(result.first.menu.meals.size).to eq 2
      expect(result.first.menu.meals.map(&:name).sort).to eq ["Hack", "Karotte"]
    end

    it "sets the day" do
      expect(result.first.day.date).to eq Date.new(2013, 10, 4)
    end
  end
end
