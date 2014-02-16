class TicketMapper < BaseMapper
  def initialize(order_mapper=OrderMapper.new, customer_mapper=CustomerMapper.new)
    @order_mapper = order_mapper
    @customer_mapper = customer_mapper
  end

  private
    def hash_from_object(ticket)
      {
        title: ticket.title,
        body:  ticket.body,
        customer_id: ticket.customer.id,
        order_id: ticket.respond_to?(:order) ? ticket.order.id : nil
      }
    end

    def object_from_hash(hash)
      customer = @customer_mapper.non_whiny_find(hash[:customer_id])

      if hash[:order_id]
        order = @order_mapper.find(hash[:order_id])

        OrderTicket.new(
          title: hash[:title],
          body: hash[:body],
          customer: customer,
          order: order
        )
      else
        Ticket.new(
          title: hash[:title],
          body: hash[:body],
          customer: customer
        )
      end
    end

    def schema_class
      Schema::Ticket
    end
end
