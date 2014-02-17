require_relative "../../app/models/ticket"

describe Ticket do
  describe "initialization" do
    it "is open by default" do
      expect(Ticket.new).to be_open
    end
  end

  describe "#close!" do
    it "closes the ticket" do
      ticket = Ticket.new
      ticket.close!
      expect(ticket.closed?).to eq true
    end
  end

  describe "#reopen!" do
    it "reopens the ticket" do
      ticket = Ticket.new
      ticket.reopen!
      expect(ticket.open?).to eq true
    end
  end
end
