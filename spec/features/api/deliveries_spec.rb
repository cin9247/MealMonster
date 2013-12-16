require "spec_helper"

describe "/api/orders/:order_id/" do
  describe "PUT /deliver" do
    let(:customer) { create_customer }

    before do
      offering = create_offering Date.new(2013, 10, 10)
      order = Interactor::CreateOrder.new(customer.id, offering.id).run.object
      put "/api/v1/orders/#{order.id}/deliver"
    end

    it "returns status 204 No Content" do
      expect(last_response.status).to eq 204
    end

    it "sets the delivered flag to true" do
      tour = create_tour("Tour", [customer.id])
      get "api/v1/tours/#{tour.id}?date=2013-10-10"

      expect(json_response["tour"]["stations"][0]["order"]["delivered"]).to eq true
    end
  end
end
