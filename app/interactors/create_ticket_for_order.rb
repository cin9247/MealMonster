require_relative "./base"
require_relative "../models/order_ticket"

module Interactor
  class CreateTicketForOrder < Base
    register_boundary :ticket_gateway, -> { TicketMapper.new }
    register_boundary :order_gateway, -> { OrderMapper.new }
    def run
      order = order_gateway.find request.order_id
      ticket_gateway.save OrderTicket.new(body: request.note, order: order, customer: order.customer)
    end
  end
end
