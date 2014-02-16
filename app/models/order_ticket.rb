require_relative "ticket"

class OrderTicket < Ticket
  attr_accessor :order

  def title
    customer.full_name
  end
end
