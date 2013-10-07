# encoding: utf-8

require "spec_helper"

describe "customers" do
  let(:organization) { Organization.new }

  describe "listing customers" do
    before do
      max   = organization.new_customer forename: "Max", surname: "Mustermann"
      heinz = organization.new_customer forename: "Heinz", surname: "Rühmann"

      max.subscribe!
      heinz.subscribe!

      visit customers_path
    end

    it "lists all customers" do
      within(".customers") do
        expect(page).to have_content "Max Mustermann"
        expect(page).to have_content "Heinz Rühmann"
      end
    end
  end

  describe "creating customers" do
    before do
      visit new_customer_path

      fill_in "Vorname", with: "Max"
      fill_in "Nachname", with: "Mustermann"

      click_on "Kunde erstellen"
    end

    it "creates the customer successfully" do
      customers = organization.customers
      expect(customers.length).to eq 1
      expect(customers.first.full_name).to eq "Max Mustermann"
    end
  end
end
