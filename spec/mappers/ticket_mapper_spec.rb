require "spec_helper"
require "interactor_spec_helper"

describe TicketMapper do
  describe "#save" do
    context "given ticket" do
      let(:customer) { Customer.new(forename: "Max") }
      let(:ticket) { Ticket.new(title: "Titel", body: "Content", customer: customer) }

      before do
        CustomerMapper.new.save customer
      end

      it "saves the ticket and its attributes" do
        subject.save ticket
        result = TicketMapper.new.fetch.first
        expect(result.is_a?(Ticket)).to eq true
        expect(result.title).to eq "Titel"
        expect(result.body).to eq "Content"
        expect(result.customer.forename).to eq "Max"
      end

      context "given open ticket" do
        it "retrieves an open ticket" do
          ticket.reopen!
          subject.save ticket
          result = subject.fetch.first
          expect(result.open?).to be_true
        end

        it "retrieves a closed ticket" do
          ticket.close!
          subject.save ticket
          result = subject.fetch.first
          expect(result.closed?).to be_true
        end
      end
    end

    context "given order ticket" do
      let(:order_mapper) { dummy_gateway }
      let(:customer_mapper) { dummy_gateway }
      subject { TicketMapper.new(order_mapper, customer_mapper) }

      it "saves the ticket and its attributes" do
        order = OpenStruct.new
        customer = OpenStruct.new(forename: "Max", full_name: "Max")
        customer_mapper.save customer
        order_mapper.save order
        subject.save OrderTicket.new(body: "Content", customer: customer, order: order)

        result = subject.fetch.first
        expect(result.is_a?(OrderTicket)).to eq true
        expect(result.body).to eq "Content"
        expect(result.customer.forename).to eq "Max"
        expect(result.order.id).to eq order.id
      end
    end
  end
end
