require "spec_helper"

describe "/api/tours" do
  let(:customer_ids) { [create_customer_with_town("Max", "Mustermann", "Karlsruhe").id, create_customer_with_town("Else", "Schmidt", "Stuttgart").id] }

  before do
    @tour_id = create_tour("Tour #1", customer_ids).id
    create_tour("Tour #2", customer_ids[0..0])

    login_as_admin_basic_auth
  end

  describe "GET /tours?date=2013-10-04" do
    before do
      get "api/v1/tours", date: date
    end

    context "given valid date" do
      let(:date) { "2013-10-04" }

      it "returns a simple description of all tours for this day" do
        expect(json_response["tours"].size).to eq 2
        first_tour = json_response["tours"][0]
        second_tour = json_response["tours"][1]
        expect(first_tour["name"]).to eq "Tour #1"
        expect(second_tour["name"]).to eq "Tour #2"
      end

      it "does not include tours which are not planned for today"
    end

    context "invalid date" do
      let(:date) { "2014-00-03" }

      it "returns 400 Bad Request" do
        expect(last_response.status).to eq 400
      end

      it "returns an error describing the problem" do
        expect(json_response["error"]).to eq "invalid date"
      end
    end
  end

  describe "GET/tours/:id?date=2013-10-04" do
    before do
      meal = create_meal "Schweineschnitzel"
      offering_id = create_offering(Date.new(2013, 10, 4), "Menü 1", [meal.id]).id
      create_order(customer_ids.first, offering_id)
    end

    before do
      get "/api/v1/tours/#{tour_id}?date=#{date}"
    end

    let(:date) { "2013-10-04" }
    let(:tour_id) { @tour_id }

    context "existing tour" do
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
      let(:tour_id) { 1337 }

      it "returns status 404" do
        expect(last_response.status).to eq 404
      end

      it "returns error message 'not found'" do
        expect(json_response["error"]).to eq "not found"
      end
    end

    context "invalid date" do
      let(:date) { "2014-00-03" }

      it "returns 400 Bad Request" do
        expect(last_response.status).to eq 400
      end

      it "returns an error describing the problem" do
        expect(json_response["error"]).to eq "invalid date"
      end
    end
  end
end
