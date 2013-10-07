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
end
