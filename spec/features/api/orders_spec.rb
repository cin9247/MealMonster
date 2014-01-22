# encoding: utf-8

require "spec_helper"

describe "/api/offerings" do
  let(:spaghetti) { create_meal "Spaghetti" }
  let(:pudding) { create_meal "Pudding", 412 }
  let(:quark) { create_meal "Quark", 500, 2.1 }
  let(:offering) { create_offering(Date.new(2013, 10, 3), "Menu #1", [spaghetti, pudding].map(&:id)) }
  let(:customer) { create_customer("Peter", "Mustermann") }
  let(:note) { "Could you guys please cook below 50°C?" }

  describe "POST /api/orders" do
    before do
      login_as_admin
      post "/api/v1/orders.json", parameters
    end

    let(:result) { json_response["order"] }

    context "given valid parameters" do
      let(:parameters) { {customer_id: customer.id, offering_id: offering.id, note: note} }

      it "returns 201 Created" do
        expect(last_response.status).to eq 201
      end

      it "creates the order" do
        expect(OrderMapper.new.fetch.size).to eq 1
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

  describe "order flags" do
    let(:customer) { create_customer }
    let(:order) { create_order(customer.id, offering.id).object}

    describe "PUT /deliver" do
      before do
        login_as_admin
        put "/api/v1/orders/#{order.id}/deliver"
      end

      it "returns status 204 No Content" do
        expect(last_response.status).to eq 204
      end

      it "sets the delivered flag to true" do
        tour = create_tour("Tour", [customer.id])
        get "api/v1/tours/#{tour.id}?date=2013-10-03"

        order = json_response["tour"]["stations"][0]["order"]

        expect(order["delivered"]).to eq true
        expect(order["loaded"]).to eq false
      end
    end

    describe "PUT /load" do
      before do
        login_as_admin
        put "/api/v1/orders/#{order.id}/load"
      end

      it "returns status 204 No Content" do
        expect(last_response.status).to eq 204
      end

      it "sets the delivered flag to true" do
        tour = create_tour("Tour", [customer.id])
        get "api/v1/tours/#{tour.id}?date=2013-10-03"

        order = json_response["tour"]["stations"][0]["order"]

        expect(order["loaded"]).to eq true
        expect(order["delivered"]).to eq false
      end
    end
  end
end
