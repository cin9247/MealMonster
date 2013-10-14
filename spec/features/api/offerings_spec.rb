require "spec_helper"

describe "/api/offerings" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let(:spaghetti) { kitchen.new_meal name: "Spaghetti" }
  let(:pudding) { kitchen.new_meal name: "Pudding", kilojoules: 412 }
  let(:quark) { kitchen.new_meal name: "Quark", bread_units: 2.1 }
  let(:first_menu) { kitchen.new_menu meals: [spaghetti, pudding] }
  let(:second_menu) { kitchen.new_menu meals: [spaghetti, quark] }
  let(:third_menu) { kitchen.new_menu meals: [spaghetti, quark] }

  let(:result) { json_response["offerings"] }

  before do
    organization.day("2013-10-03").offer! first_menu
    organization.day("2013-10-03").offer! second_menu
    organization.day("2013-10-04").offer! third_menu
  end

  describe "GET /api/offerings?date=?" do
    context "given a valid date" do

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
