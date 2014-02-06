class TicketMapper < BaseMapper
  private
    def hash_from_object(ticket)
      {
        title: ticket.title,
        body:  ticket.body,
        customer_id: ticket.customer.id
      }
    end

    def object_from_hash(hash)
      customer = CustomerMapper.new.non_whiny_find(hash[:customer_id])

      Ticket.new(
        title: hash[:title],
        body: hash[:body],
        customer: customer
      )
    end

    def schema_class
      Schema::Ticket
    end
end
