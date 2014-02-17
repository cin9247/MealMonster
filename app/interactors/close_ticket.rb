require_relative "./base"

module Interactor
  class CloseTicket < Base
    register_boundary :ticket_gateway, -> { TicketMapper.new }

    def run
      ticket = ticket_gateway.find request.ticket_id
      ticket.close!

      ticket_gateway.update ticket

      OpenStruct.new object: ticket
    end
  end
end
