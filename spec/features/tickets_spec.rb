require "spec_helper"

describe "tickets" do
  let!(:customer_1) { create_customer "Hans", "Mustermann" }
  let!(:customer_2) { create_customer "Peter" }

  describe "list of tickets" do
    let!(:ticket_1) { create_ticket("Essen ist blöd", "Ich habe ein Problem!", customer_1.id) }
    let!(:ticket_2) { create_ticket("Hilfe!", "Wieso geht das nicht?", customer_2.id) }

    before do
      login_as_admin_web
      visit tickets_path
    end

    it "lists the tickets" do
      within(".tickets") do
        expect(page).to have_css(".title", text: "Essen ist blöd")
        expect(page).to have_css(".title", text: "Hilfe!")
        expect(page).to have_css(".status", text: "Offen")
        expect(page).to have_css(".customer", text: "Hans")
        expect(page).to have_css(".customer", text: "Peter")
      end
    end

    it "can show details" do
      click_on "##{ticket_1.id}"

      expect(page).to have_content "Ich habe ein Problem!"
    end
  end

  describe "creating tickets" do
    before do
      login_as_admin_web
      visit tickets_path
      click_on "Neues Ticket erstellen"

      fill_in "Titel", with: "Problem"
      fill_in "Beschreibung", with: "Ein sehr großes!"
      select "Hans Mustermann", from: "Kunde"

      click_on "Ticket erstellen"
    end

    it "redirects to the tickets path" do
      expect(current_path).to eq tickets_path
    end

    it "has created the new ticket" do
      within(".tickets") do
        expect(page).to have_content "Hans Mustermann"
        expect(page).to have_content "Problem"
      end
    end
  end

  describe "closing tickets" do
    before do
      login_as_admin_web
      ticket = create_ticket("Unclosed Ticket", "Some body", customer_1.id)
      visit ticket_path(ticket)

      click_on "Ticket schließen"
    end

    it "closes the ticket" do
      expect(TicketMapper.new.fetch.first.closed?).to eq true
    end

    it "redirects to tickets path" do
      expect(current_path).to eq tickets_path
    end
  end

  describe "reopening tickets" do
    before do
      login_as_admin_web
      ticket = create_ticket("Unclosed Ticket", "Some body", customer_1.id)
      close_ticket ticket.id
      visit ticket_path(ticket)

      click_on "Ticket wieder öffnen"
    end

    it "closes the ticket" do
      expect(TicketMapper.new.fetch.first.open?).to eq true
    end

    it "redirects to tickets path" do
      expect(current_path).to eq tickets_path
    end
  end
end
