require "spec_helper"

describe OrderMapper do
  let(:meal_1) { create_meal "Hack" }
  let(:meal_2) { create_meal "Karotte" }
  let(:date_1) { Date.new(2013, 10, 6) }
  let(:date_2) { Date.new(2013, 10, 7) }
  let(:offering_1) { create_offering(date_1, "Menu #1", [meal_1.id, meal_2.id]) }
  let(:offering_2) { create_offering(date_2, "Menu #2", [meal_1.id]) }
  let(:customer) { create_customer "Hans" }
  let(:other_customer) { create_customer "Peter" }
  let(:order_1) { Order.new offerings: [offering_1], customer: customer }
  let(:order_2) { Order.new offerings: [offering_2], customer: customer }
  let(:order_3) { Order.new offerings: [offering_2], customer: other_customer }

  describe "#fetch" do
    before do
      subject.save order_1
    end

    let(:result) { subject.fetch }
    let(:first_order) { result.first }

    it "fetches all offerings" do
      expect(result.size).to eq 1
    end

    it "fetches the menu for the offering" do
      expect(first_order.offerings.first.name).to eq "Menu #1"
    end

    it "fetches each offering for the offered menu" do
      expect(first_order.offerings.first.menu.meals.size).to eq 2
      expect(first_order.offerings.first.menu.meals.map(&:name).sort).to eq ["Hack", "Karotte"]
    end

    it "sets the date" do
      expect(first_order.date).to eq Date.new(2013, 10, 6)
    end
  end

  describe "order has many offerings" do
    it "saves links to the offerings" do
      subject.save Order.new(offerings: [offering_1, offering_2], customer: customer)

      result = subject.fetch
      expect(result.size).to eq 1

      expect(result.first.offerings.size).to eq 2
      expect(result.first.offerings.first.id).to eq offering_1.id
      expect(result.first.offerings.last.id).to eq offering_2.id
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
