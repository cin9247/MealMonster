require_relative "./base"

module Interactor
  class ListTickets < Base
    register_boundary :ticket_gateway, -> { TicketMapper.new }

    def run
      OpenStruct.new object: ticket_gateway.fetch
    end
  end
end
