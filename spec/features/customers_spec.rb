# encoding: utf-8

require "spec_helper"

describe "customers" do
  before do
    login_as_admin_web

    CatchmentAreaMapper.new.save CatchmentArea.new(name: "Else-Heydlauf-Stiftung")
    CatchmentAreaMapper.new.save CatchmentArea.new(name: "Krankenhaus")
  end

  describe "listing customers" do
    before do
      customer_1 = create_customer("Max", "Mustermann")
      create_customer_with_town("Heinz", "Rühmann", "München")

      visit customers_path
    end

    it "lists all customers" do
      within(".customers") do
        expect(page).to have_content "Max"
        expect(page).to have_content "Mustermann"
        expect(page).to have_content "Heinz"
        expect(page).to have_content "Rühmann"
        expect(page).to have_content "München"
      end
    end
  end

  describe "creating customers" do
    before do
      visit new_customer_path

      fill_in "Anrede", with: "Herr"
      fill_in "Vorname", with: "Max"
      fill_in "Nachname", with: "Mustermann"
      fill_in "Telefonnummer", with: "0174/257 12 42"
      fill_in "Stadt", with: "Karslruhe"
      fill_in "Bemerkung", with: "Kann nicht selbststaendig Tuer oeffnen."
      fill_in "Geburtsdatum", with: "20.10.1937"
      fill_in "E-Mail", with: "post@web.de"

      select "Else-Heydlauf-Stiftung", from: "Einzugsgebiet"

      click_on "Kunde erstellen"
    end

    it "creates the customer successfully" do
      customers = CustomerMapper.new.fetch
      expect(customers.length).to eq 1
      expect(customers.first.full_name).to eq "Max Mustermann"
      expect(customers.first.telephone_number).to eq "0174/257 12 42"
      expect(customers.first.address.town).to eq "Karslruhe"
      expect(customers.first.prefix).to eq "Herr"
      expect(customers.first.catchment_area.name).to eq "Else-Heydlauf-Stiftung"
      expect(customers.first.note).to eq "Kann nicht selbststaendig Tuer oeffnen."
      expect(customers.first.date_of_birth).to eq Date.new(1937, 10, 20)
      expect(customers.first.email).to eq "post@web.de"
    end
  end

  describe "editing customers" do
    before do
      create_customer("Peter", "Mustermann")

      visit customers_path
      click_on "Editieren"

      fill_in "Vorname", with: "Max"
      fill_in "Stadt", with: "Berlin"
      fill_in "Telefonnummer", with: "28"
      fill_in "Bemerkung", with: "Bringt mir alles ans Bett!"

      select "Krankenhaus", from: "Einzugsgebiet"

      click_on "Kunde aktualisieren"
    end

    it "updates the customer" do
      visit customers_path
      click_on "Details"

      expect(page).to have_content "28"
      expect(page).to have_content("Max Mustermann")
      expect(page).to have_content("Berlin")
      expect(page).to have_content("Krankenhaus")
      expect(page).to have_content("Bringt mir alles ans Bett!")
    end
  end

  describe "displaying a single customer" do
    before do
      customer = create_customer("Peter", "Mustermann", "Bla.")

      visit customer_path(customer)
    end

    it "displays the name of the customer" do
      expect(page).to have_content "Peter Mustermann"
      expect(page).to have_content "Bla."
    end
  end
end
