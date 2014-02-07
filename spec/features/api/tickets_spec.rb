require "spec_helper"

describe "service tickets" do
  describe "creation of service tickets" do
    let(:customer) { create_customer }
    let(:parameters) {{
                        title: "Ihr Essen bekommt mir nicht gut...",
                        body: "Es ging mit einmal spülen gar nicht runter!",
                        customer_id: customer.id
                     }}
    before do
      login_as_admin_basic_auth
      post "/api/v1/tickets.json", parameters
    end

    it "responds with 201 Created" do
      expect(last_response.status).to eq 201
    end

    it "creates the ticket" do
      tickets = TicketMapper.new.fetch
      expect(tickets.size).to eq 1
      expect(tickets.first.title).to eq parameters[:title]
      expect(tickets.first.body).to eq parameters[:body]
      expect(tickets.first.customer.id).to eq customer.id
    end
  end
end
