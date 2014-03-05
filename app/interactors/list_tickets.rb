require_relative "./base"

module Interactor
  class ListTickets < Base
    register_boundary :ticket_gateway, -> { TicketMapper.new }

    def run
      closed_tickets = ticket_gateway.fetch_closed
      opened_tickets = ticket_gateway.fetch_opened
      OpenStruct.new object: {opened: opened_tickets, closed: closed_tickets}
    end
  end
end
