require "spec_helper"

describe "/api/tours" do
  let(:customer_ids) { [create_customer("Max Mustermann").id, create_customer("Else Schmidt").id] }

  before do
    @tour_id = Interactor::CreateTour.new("Tour #1", customer_ids).run.object.id
  end

  describe "GET /tours?date=2013-10-04" do
    before do
      get "api/v1/tours", date: "2013-10-04"
    end

    it "returns a simple description of all tours for this day" do
      first_tour = json_response["tours"][0]
      expect(first_tour["name"]).to eq "Tour #1"
    end

    it "does not include tours which are not planned for today"
  end

  describe "GET/tours/:id?date=2013-10-04" do
    before do
      meal = create_meal "Schweineschnitzel"
      offering_id = Interactor::CreateOffering.new(Date.new(2013, 10, 4), [meal.id]).run.object.id
      Interactor::CreateOrder.new(customer_ids.first, offering_id).run
      get "api/v1/tours/#{@tour_id}?date=2013-10-04"
    end

    it "returns all stations for that day" do
      tour = json_response["tour"]
      expect(tour["name"]).to eq "Tour #1"

      expect(tour["stations"].size).to eq 1
      expect(tour["stations"].first["customer"]["forename"]).to eq "Max"
    end
  end
end
