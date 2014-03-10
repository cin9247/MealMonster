require_relative "./base"
require_relative "../models/order_ticket"

module Interactor
  class CancelOrder < Base
    register_boundary :order_gateway,    -> { OrderMapper.new }
    register_boundary :ticket_gateway,   -> { TicketMapper.new }

    def run
      # TODO wrap in transaction
      order = order_gateway.find request.order_id
      order.cancel!

      order_gateway.update order

      ticket = OrderTicket.new(title: "Stornierung der Bestellung", body: "Diese Bestellung wurde storniert.\n\nGrund: #{request.reason}", order: order, customer: order.customer)
      ticket_gateway.save ticket
    end
  end
end
