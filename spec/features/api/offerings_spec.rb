require "spec_helper"

describe "/api/offerings" do
  let(:organization) { Organization.new }

  let(:spaghetti) { Meal.new name: "Spaghetti" }
  let(:pudding) { Meal.new name: "Pudding", kilojoules: 412 }
  let(:quark) { Meal.new name: "Quark", bread_units: 2.1 }
  let(:first_menu) { Menu.new meals: [spaghetti, pudding] }
  let(:second_menu) { Menu.new meals: [spaghetti, quark] }
  let(:third_menu) { Menu.new meals: [spaghetti, quark] }

  let(:result) { json_response["offerings"] }

  before do
    organization.day("2013-10-03").offer! first_menu
    organization.day("2013-10-03").offer! second_menu
    organization.day("2013-10-04").offer! third_menu
    organization.day("2013-10-07").offer! third_menu

    login_as_admin
  end

  describe "GET /api/offerings?date=?" do
    context "given a single date" do

      before do
        get "/api/v1/offerings?date=2013-10-03"
      end

      it "returns 200 OK" do
        expect(last_response.status).to eq 200
      end

      it "returns all offerings for that day" do
        expect(result.length).to eq 2
        expect(result[0]["date"]).to eq "2013-10-03"
      end

      it "includes all meals" do
        expect(result[0]["meals"][0]["name"]).to eq "Spaghetti"
        expect(result[0]["meals"][1]["name"]).to eq "Pudding"
        expect(result[1]["meals"][0]["name"]).to eq "Spaghetti"
        expect(result[1]["meals"][1]["name"]).to eq "Quark"
        expect(result[1]["meals"][1]["bread_units"]).to eq 2.1
        expect(result[0]["meals"][1]["kilojoules"]).to eq 412
      end

    end

    context "given a date range" do
      before do
        get "/api/v1/offerings?from=2013-10-03&to=2013-10-05"
      end

      it "returns 200 OK" do
        expect(last_response.status).to eq 200
      end

      it "returns all offerings which lie in the given date range" do
        expect(result.size).to eq 3
        expect(result[0]["meals"][0]["name"]).to eq "Spaghetti"
        expect(result[0]["meals"][1]["name"]).to eq "Pudding"
      end
    end

    context "given an invalid date" do
      before do
        get "/api/v1/offerings?date=2013/441-12"
      end

      it "returns 400 Bad Request" do
        expect(last_response.status).to eq 400
      end

      it "returns an error mentioning the invalid date" do
        messages = json_response["errors"].map { |e| e["message"] }
        expect(messages).to include "invalid date"
      end
    end
  end
end
