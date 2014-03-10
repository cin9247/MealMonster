# encoding: utf-8

require "spec_helper"

describe "/api/orders" do
  let(:spaghetti) { create_meal "Spaghetti" }
  let(:pudding) { create_meal "Pudding", 412 }
  let(:quark) { create_meal "Quark", 500, 2.1 }
  let(:date) { Date.new(2013, 10, 3) }
  let(:offering) { create_offering(date, "Menu #1", [spaghetti, pudding].map(&:id)) }
  let(:customer) { create_customer("Peter", "Mustermann") }
  let(:note) { "Could you guys please cook below 50°C?" }

  describe "POST /api/orders" do
    before do
      login_as_admin_basic_auth
      post "/api/v1/orders.json", parameters
    end

    let(:result) { json_response["order"] }

    context "given valid parameters" do
      let(:parameters) { {customer_id: customer.id, offering_id: offering.id, note: note} }

      it "returns 201 Created" do
        expect(last_response.status).to eq 201
      end

      it "creates the order" do
        orders = OrderMapper.new.fetch
        expect(orders.size).to eq 1
        expect(orders.first.date).to eq Date.new(2013, 10, 3)
        expect(orders.first.offerings.first.name).to eq "Menu #1"
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
    let(:order) { create_order(customer.id, offering.id) }

    describe "PUT /deliver" do
      before do
        login_as_admin_basic_auth
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
        login_as_admin_basic_auth
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

    describe "POST /note" do
      before do
        login_as_admin_basic_auth
        post "/api/v1/orders/#{order.id}/note", note: "Der Kerl war nicht da!"
      end

      it "returns status 204 No Content" do
        expect(last_response.status).to eq 204
      end

      it "creates a new ticket for the order" do
        tickets = TicketMapper.new.fetch
        expect(tickets.size).to eq 1
        expect(tickets.first.title).to include "Fahrer-Bemerkung"
        expect(tickets.first.body).to eq "Der Kerl war nicht da!"
        expect(tickets.first.order.id).to eq order.id
      end
    end
  end

  describe "list of orders" do
    before do
      @o_1 = create_offering Date.new(2014, 2, 4), "M1"
      @o_2 = create_offering Date.new(2014, 2, 3), "M2"
      @o_3 = create_offering Date.new(2014, 2, 5), "M3"

      @order_1 = create_order customer.id, @o_1.id
      @order_2 = create_order customer.id, @o_2.id
      @order_3 = create_order customer.id, @o_3.id

      login_as_admin_basic_auth
      get "/api/v1/customers/#{customer.id}/orders/", from: Date.new(2014, 2, 2), to: Date.new(2014, 2, 4)
    end

    it "returns 200 OK" do
      expect(last_response.status).to eq 200
    end

    it "returns the orders for this customer" do
      orders = json_response["orders"]
      expect(orders.size).to eq 2
      expect(orders.map { |o| o["id"] }).to eq [@order_2.id, @order_1.id]
      expect(orders.map { |o| o["date"] }).to eq [@order_2.date.iso8601, @order_1.date.iso8601]

      expect(orders.first["offerings"].first["id"]).to eq @o_2.id
      expect(orders.last["offerings"].first["id"]).to eq @o_1.id

      expect(orders.first["offerings"].first["name"]).to eq "M2"

      expect(orders.first["offerings"].first["meals"].first["name"]).to eq @order_2.offerings.first.menu.meals.first.name
    end
  end

  describe "POST /orders/:id/cancel" do
    let(:customer) { create_customer }
    let(:order) { create_order(customer.id, offering.id) }

    before do
      login_as_admin_basic_auth
      post "/api/v1/orders/#{order.id}/cancel"
    end

    it "returns 201 Created" do
      expect(last_response.status).to eq 201
    end

    it "removes the order from the API response" do
      get "/api/v1/customers/#{customer.id}/orders/", from: date, to: date
      expect(json_response["orders"]).to eq []
    end
  end
end
