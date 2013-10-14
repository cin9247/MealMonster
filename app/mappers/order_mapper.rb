class OrderMapper < BaseMapper
  def save(record)
    raise "order.offering must've been already saved" unless record.offering.id
    raise "order.customer must've been already saved" unless record.customer.id

    super
  end

  private
    def hash_from_object(order)
      {
        date: order.day.date,
        customer_id: order.customer.id,
        offering_id: order.offering.id
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      offering = OfferingMapper.new.send :convert_to_object_and_set_id, order.offering

      ## TODO day creation??? which day if we have several?
      Order.new day: Day.new(date: order[:date]), offering: offering, customer: customer
    end

    def schema_class
      Schema::Order
    end
end
