# encoding: utf-8

require "spec_helper"

describe "api/tours/:id/keys" do
  describe "GET /keys" do
    let(:customer_1) { create_customer_with_town("Peter", "Mustermann", "Karlsruhe") }
    let(:customer_2) { create_customer_with_town("Maria", "Mustermann", "Stuttgart") }
    let(:customer_3) { create_customer_with_town("David", "Mustermann", "Nürnberg") }

    before do
      offering = create_offering Date.new(2013, 11, 11)
      add_key_for_customer(customer_1, "Schlüssel 4")
      add_key_for_customer(customer_2, "Schlüssel 6")
      add_key_for_customer(customer_3, "Schlüssel 10")
      create_order(customer_1.id, offering.id)
      create_order(customer_2.id, offering.id)

      tour = create_tour("Tour #1", [customer_1.id, customer_2.id])

      login_as_admin_basic_auth
      get "api/v1/tours/#{tour.id}/keys?date=2013-11-11"
    end

    it "returns status 200" do
      expect(last_response.status).to eq 200
    end

    it "returns all keys for the customers in this tour" do
      expect(json_response["keys"].size).to eq 2
      expect(json_response["keys"].first["name"]).to eq "Schlüssel 4"
      expect(json_response["keys"].first["customer_id"]).to eq customer_1.id
      expect(json_response["keys"].last["name"]).to eq "Schlüssel 6"
      expect(json_response["keys"].last["customer_id"]).to eq customer_2.id
    end
  end
end
