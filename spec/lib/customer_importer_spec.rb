require "interactor_spec_helper"
require "customer_importer"

describe CustomerImporter do
  describe "#import" do
    let(:customers_gateway) { dummy_gateway }
    let(:tour_gateway) { dummy_gateway }
    let(:catchment_area_gateway) { dummy_gateway }
    subject { CustomerImporter.new("spec/fixtures/customers.csv", customers_gateway, tour_gateway, catchment_area_gateway) }

    before do
      subject.import!
    end

    it "imports the correct amount of users" do
      expect(customers_gateway.fetch.size).to eq 4
    end

    it "has the correct attributes for the first customer" do
      c = customers_gateway.fetch.first
      expect(c.prefix).to eq "Herr"
      expect(c.forename).to eq "Albert"
      expect(c.surname).to eq "Linsenmaier"
      expect(c.note).to eq "keine blähende Speisen,Fleisch schneiden"
      expect(c.telephone_number).to eq "574358"
    end

    it "fills out the address correctly" do
      a = customers_gateway.fetch.first.address
      expect(a.street_name).to eq "Burgstr."
      expect(a.street_number).to eq "30"
      expect(a.postal_code).to eq "70734"
      expect(a.town).to eq "Fellbach"
    end

    it "still keeps a decent state of the street name if someone messed up" do
      expect(customers_gateway.fetch.last.address.street_name).to eq "Waiblingerstr.64"
    end

    it "creates the tours" do
      tours = tour_gateway.fetch
      expect(tours.size).to eq 6
      customers_for_6W = tours.find { |t| t.name == "6W" }.customers
      expect(customers_for_6W.size).to eq 2
      expect(customers_for_6W.first.forename).to eq "Hildegard"
      expect(customers_for_6W.last.forename).to eq "Annemarie"
    end

    it "assigns customers to catchment areas" do
      expect(customers_gateway.fetch.first.catchment_area.name).to eq "MM-HAK"
      expect(customers_gateway.fetch.last.catchment_area.name).to eq "MM-KWH"
    end
  end
end
