require "spec_helper"

describe "/api/offerings" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let(:spaghetti) { kitchen.new_meal name: "Spaghetti" }
  let(:pudding) { kitchen.new_meal name: "Pudding", kilojoules: 412 }
  let(:quark) { kitchen.new_meal name: "Quark", bread_units: 2.1 }
  let(:first_menu) { kitchen.new_menu meals: [spaghetti, pudding] }
  let(:second_menu) { kitchen.new_menu meals: [spaghetti, quark] }
  let(:third_menu) { kitchen.new_menu meals: [spaghetti, quark] }
  let(:customer) { organization.new_customer forename: "Peter" }

  before do
    organization.day("2013-10-03").offer! first_menu
    organization.day("2013-10-03").offer! second_menu
    organization.day("2013-10-04").offer! third_menu
    customer.subscribe!
  end

  describe "POST /api/orders" do
    let(:result) { json_response["order"] }

    context "given valid parameters" do
      before do
        offering = organization.day("2013-10-03").offerings.find { |o| o.menu.id == first_menu.id }
        post "/api/v1/orders.json", {customer_id: customer.id, date: "2013-10-03", offering_id: offering.id}
      end

      it "returns 201 Created" do
        expect(last_response.status).to eq 201
      end

      it "creates the order" do
        expect(organization.orders.size).to eq 1
      end

      it "returns a representation of the created order" do
        expect(result["menu"]["meals"][1]["name"]).to eq "Pudding"
      end
    end

    context "given missing parameters" do
    end

    context "given offering doesn't exist for this date" do
    end
  end
end
