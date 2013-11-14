require "spec_helper"

describe "/api/tours" do
  before do
    customer_ids = [create_customer("Max Mustermann"), create_customer("Else Schmidt")]
    Interactor::CreateTour.new("Tour #1", customer_ids).run
  end

  describe "GET /tours?date=2013-10-04" do
    before do
      get "api/v1/tours", date: "2013-10-04"
    end

    it "returns all stations for this day" do
      first_tour = json_response["tours"][0]
      expect(first_tour["name"]).to eq "Tour #1"
      expect(first_tour["stations"].size).to eq 2
      expect(first_tour["stations"][0]["customer"]["forename"]).to eq "Max"
    end
  end
end
