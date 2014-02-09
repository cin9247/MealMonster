require_relative "./base"
require_relative "../models/ticket"

module Interactor
  class CreateTicket < Base
    register_boundary :ticket_gateway,    -> { TicketMapper.new }
    register_boundary :customer_gateway,  -> { CustomerMapper.new }

    def run
      customer = customer_gateway.find request.customer_id
      ticket = Ticket.new title: request.title, body: request.body, customer: customer

      if ticket.valid?
        ticket_gateway.save ticket
        OpenStruct.new status: :successfully_created, object: ticket
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
