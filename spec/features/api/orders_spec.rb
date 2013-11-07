# encoding: utf-8

require "spec_helper"

describe "/api/offerings" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let(:spaghetti) { kitchen.new_meal name: "Spaghetti" }
  let(:pudding) { kitchen.new_meal name: "Pudding", kilojoules: 412 }
  let(:quark) { kitchen.new_meal name: "Quark", bread_units: 2.1 }
  let(:menu) { kitchen.new_menu meals: [spaghetti, pudding] }
  let(:offering) { organization.day("2013-10-03").offer! menu }
  let(:customer) { organization.new_customer forename: "Peter" }
  let(:note) { "Could you guys please cook below 50°C?" }

  before do
    Interactor::CreateCustomer.new(customer).run
  end

  describe "POST /api/orders" do
    before do
      post "/api/v1/orders.json", parameters
    end

    let(:result) { json_response["order"] }

    context "given valid parameters" do
      let(:parameters) { {customer_id: customer.id, offering_id: offering.id, note: note} }

      it "returns 201 Created" do
        expect(last_response.status).to eq 201
      end

      it "creates the order" do
        expect(organization.orders.size).to eq 1
      end

      it "returns a representation of the created order" do
        expect(result["menu"]["meals"][1]["name"]).to eq "Pudding"
      end

      it "returns the note" do
        expect(result["note"]).to eq note
      end
    end

    context "given missing customer_id" do
      let(:parameters) { {offering_id: offering.id} }

      it "returns 400 Bad Request" do
        expect(last_response.status).to eq 400
      end

      it "returns a description of the error" do
        expect(json_response["errors"].size).to eq 1
        expect(json_response["errors"][0]["message"]).to eq "customer_id is missing"
      end
    end
  end
end