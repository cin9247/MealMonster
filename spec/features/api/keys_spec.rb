# encoding: utf-8

require "spec_helper"

describe "api/tours/:id/keys" do
  describe "GET /keys" do
    before do
      offering = create_offering Date.new(2013, 11, 11)
      customer_1 = create_customer_with_town("Peter", "Mustermann", "Karlsruhe")
      customer_2 = create_customer_with_town("Maria", "Mustermann", "Stuttgart")
      customer_3 = create_customer_with_town("David", "Mustermann", "Nürnberg")
      Interactor::AddKeyToAddress.new(customer_1.address.id, "Schlüssel 4").run
      Interactor::AddKeyToAddress.new(customer_2.address.id, "Schlüssel 6").run
      Interactor::AddKeyToAddress.new(customer_3.address.id, "Schlüssel 10").run
      Interactor::CreateOrder.new(customer_1.id, offering.id).run
      Interactor::CreateOrder.new(customer_2.id, offering.id).run
      tour = create_tour("Tour #1", [customer_1.id, customer_2.id])

      get "api/v1/tours/#{tour.id}/keys?date=2013-11-11"
    end

    it "returns status 200" do
      expect(last_response.status).to eq 200
    end

    it "returns all keys for the customers in this tour" do
      expect(json_response["keys"].size).to eq 2
      expect(json_response["keys"].first["name"]).to eq "Schlüssel 4"
      expect(json_response["keys"].last["name"]).to eq "Schlüssel 6"
    end
  end
end
