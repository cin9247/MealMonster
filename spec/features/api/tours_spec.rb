require "spec_helper"

describe "/api/tours" do
  def create_customer_temp(forename, surname, town, note="", telephone_number="")
    customer = create_customer_with_town(forename, surname, town, note)
    customer.telephone_number = telephone_number
    CustomerMapper.new.update customer
    customer
  end

  let(:customer_ids) { [create_customer_temp("Max", "Mustermann", "Karlsruhe", "Kann nichts.", "0170 33 44 55").id, create_customer_temp("Else", "Schmidt", "Stuttgart").id] }
  let(:driver) { create_driver("Max Speed") }

  before do
    @tour_id = create_tour("Tour #1", customer_ids).id
    create_tour("Tour #2", customer_ids[0..0])

    set_driver_for_tour(driver.id, @tour_id)

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
        names = json_response["tours"].map { |t| t["name"] }
        expect(names).to include "Tour #1"
        expect(names).to include "Tour #2"
      end

      it "returns the driver" do
        expect(json_response["tours"][1]["driver"]["name"]).to eq "Max Speed"
        expect(json_response["tours"][1]["driver"]["id"]).to eq driver.id
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

  describe "GET/tours/:id?date=2013-10-04" do
    before do
      meal = create_meal "Schweineschnitzel"
      offering_id = create_offering(Date.new(2013, 10, 4), "Menü 1", [meal.id]).id
      @order = create_order(customer_ids.first, offering_id)

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
        expect(tour["stations"].first["customer"]["note"]).to eq "Kann nichts."
        expect(tour["stations"].first["customer"]["telephone_number"]).to eq "0170 33 44 55"
        expect(tour["stations"].first["order"]["delivered"]).to eq false
        expect(tour["stations"].first["order"]["loaded"]).to eq false
        expect(tour["stations"].first["order"]["id"]).to eq @order.id
        expect(tour["stations"].first["order"]["offerings"].first["name"]).to eq "Menü 1"
        expect(tour["stations"].first["order"]["offerings"].first["meals"].first["name"]).to eq "Schweineschnitzel"
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
