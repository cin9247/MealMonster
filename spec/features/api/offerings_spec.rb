require "spec_helper"

describe "/api/offerings" do
  let(:organization) { Organization.new }
  let(:kitchen) { organization.kitchen }

  let(:spaghetti) { kitchen.new_meal name: "Spaghetti" }
  let(:pudding) { kitchen.new_meal name: "Pudding" }
  let(:quark) { kitchen.new_meal name: "Quark", bread_units: 2.1 }
  let(:first_menu) { kitchen.new_menu meals: [spaghetti, pudding] }
  let(:second_menu) { kitchen.new_menu meals: [spaghetti, quark] }
  let(:third_menu) { kitchen.new_menu meals: [spaghetti, quark] }

  let(:json_response) { JSON.parse last_response.body }
  let(:result) { json_response["offerings"] }

  describe "GET /api/offerings?date=2013-10-03" do
    before do
      kitchen.day("2013-10-03").offer! first_menu
      kitchen.day("2013-10-03").offer! second_menu
      kitchen.day("2013-10-04").offer! third_menu

      get "/api/v1/offerings?date=2013-10-03"
    end

    it "should return 200 OK" do
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
    end
  end
end
