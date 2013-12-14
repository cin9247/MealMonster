# encoding: utf-8

require "spec_helper"

describe "customers" do
  let(:organization) { Organization.new }

  describe "listing customers" do
    before do
      customer_1 = create_customer("Max", "Mustermann")
      create_customer("Heinz", "Rühmann")

      Interactor::AddAddressToCustomer.new(customer_1.id, "Heinestr.", "43", "74123", "München").run

      visit customers_path
    end

    it "lists all customers" do
      within(".customers") do
        expect(page).to have_content "Max Mustermann"
        expect(page).to have_content "Heinz Rühmann"
        expect(page).to have_content "München"
      end
    end
  end

  describe "creating customers" do
    before do
      visit new_customer_path

      fill_in "Vorname", with: "Max"
      fill_in "Nachname", with: "Mustermann"
      fill_in "Stadt", with: "Karslruhe"

      click_on "Kunde erstellen"
    end

    it "creates the customer successfully" do
      customers = organization.customers
      expect(customers.length).to eq 1
      expect(customers.first.full_name).to eq "Max Mustermann"
      expect(customers.first.address.town).to eq "Karslruhe"
    end
  end

  describe "editing customers" do
    before do
      create_customer("Peter", "Mustermann")

      visit customers_path
      click_on "Editieren"

      fill_in "Vorname", with: "Max"
      fill_in "Stadt", with: "Berlin"

      click_on "Kunde aktualisieren"
    end

    it "updates the customer" do
      visit customers_path

      expect(page).to have_content("Max Mustermann")
      expect(page).to have_content("Berlin")
    end
  end

  describe "displaying a single customer" do
    before do
      customer = organization.new_customer(forename: "Peter", surname: "Mustermann")
      customer = create_customer("Peter", "Mustermann")

      visit customer_path(customer)
    end

    it "displays the name of the customer" do
      expect(page).to have_content "Peter Mustermann"
    end
  end
end
