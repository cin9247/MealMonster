class TicketMapper < BaseMapper
  def initialize(order_mapper=OrderMapper.new, customer_mapper=CustomerMapper.new)
    @order_mapper = order_mapper
    @customer_mapper = customer_mapper
  end

  def fetch
    schema_class.order(Sequel.desc(:status), Sequel.desc(:created_at)).map do |t|
      convert_to_object_and_set_id t
    end
  end

  private
    def hash_from_object(ticket)
      {
        title: ticket.title,
        body:  ticket.body,
        customer_id: ticket.customer.id,
        order_id: ticket.respond_to?(:order) ? ticket.order.id : nil,
        status: ticket.open? ? "open" : "closed"
      }
    end

    def object_from_hash(hash)
      customer = @customer_mapper.non_whiny_find(hash[:customer_id])

      result = if hash[:order_id]
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

      if hash[:status] == "closed"
        result.close!
      end

      result
    end

    def schema_class
      Schema::Ticket
    end
end
