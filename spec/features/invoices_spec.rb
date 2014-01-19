require "spec_helper"

describe "invoices" do
  describe "for one customer" do
    let(:customer) { create_customer }
    let(:date) { Date.new(2013, 2, 2) }
    let(:offering_1) { create_offering(date, "Menü #1") }
    let(:offering_2) { create_offering(date, "Menü #2") }
    let(:offering_3) { create_offering(date + 1.day, "Aufschnitt") }
    let(:offering_4) { create_offering(date + 2.day, "Frühstück") }

    before do
      create_order(customer, offering_2)
      create_order(customer, offering_4)

      visit customer_invoices_path(customer)
    end

    it "displays the ordered offerings" do
      expect(page).to have_content "Menü #2"
      expect(page).to have_content "Frühstück"
      expect(page).to_not have_content "Menü #1"
      expect(page).to_not have_content "Aufschnitt"
    end
  end
end
