class OrderMapper < BaseMapper
  def save(record)
    raise "order.offering must've been already saved" unless record.offering.id
    raise "order.customer must've been already saved" unless record.customer.id

    super
  end

  private
    def hash_from_object(order)
      {
        date: order.date,
        customer_id: order.customer.id,
        offering_id: order.offering.id,
        note: order.note
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      offering = OfferingMapper.new.send :convert_to_object_and_set_id, order.offering

      Order.new(
        day: Day.new(date: order[:date]),
        offering: offering,
        customer: customer,
        note: order[:note]
      )
    end

    def schema_class
      Schema::Order
    end
end
