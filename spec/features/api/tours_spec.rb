require "spec_helper"

describe "/api/tours" do
  let(:customer_ids) { [create_customer_with_town("Max", "Mustermann", "Karlsruhe").id, create_customer_with_town("Else", "Schmidt", "Stuttgart").id] }

  before do
    @tour_id = Interactor::CreateTour.new("Tour #1", customer_ids).run.object.id
    Interactor::CreateTour.new("Tour #2", customer_ids[0..0]).run
  end

  describe "GET /tours?date=2013-10-04" do
    before do
      get "api/v1/tours", date: "2013-10-04"
    end

    it "returns a simple description of all tours for this day" do
      expect(json_response["tours"].size).to eq 2
      first_tour = json_response["tours"][0]
      second_tour = json_response["tours"][1]
      expect(first_tour["name"]).to eq "Tour #1"
      expect(second_tour["name"]).to eq "Tour #2"
    end

    it "does not include tours which are not planned for today"
  end

  describe "GET/tours/:id?date=2013-10-04" do
    before do
      meal = create_meal "Schweineschnitzel"
      offering_id = Interactor::CreateOffering.new(Date.new(2013, 10, 4), [meal.id]).run.object.id
      Interactor::CreateOrder.new(customer_ids.first, offering_id).run
    end

    context "existing tour" do
      before do
        get "api/v1/tours/#{@tour_id}?date=2013-10-04"
      end

      it "returns all stations for that day" do
        tour = json_response["tour"]
        expect(tour["name"]).to eq "Tour #1"

        expect(tour["stations"].size).to eq 1
        expect(tour["stations"].first["customer"]["forename"]).to eq "Max"
        expect(tour["stations"].first["customer"]["address"]["town"]).to eq "Karlsruhe"
        expect(tour["stations"].first["order"]["delivered"]).to eq false
        expect(tour["stations"].first["order"]["loaded"]).to eq false
      end
    end

    context "non-existing tour" do
      before do
        get "/api/v1/tours/1337?date=2013-10-04"
      end

      it "returns status 404" do
        expect(last_response.status).to eq 404
      end

      it "returns error message 'not found'" do
        expect(json_response["error"]).to eq "not found"
      end
    end
  end
end
