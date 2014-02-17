require_relative "./base"

module Interactor
  class ReopenTicket < Base
    register_boundary :ticket_gateway, -> { TicketMapper.new }

    def run
      ticket = ticket_gateway.find request.ticket_id
      ticket.reopen!

      ticket_gateway.update ticket

      OpenStruct.new object: ticket
    end
  end
end
