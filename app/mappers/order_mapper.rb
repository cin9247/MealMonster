class OrderMapper < BaseMapper
  def save(record)
    raise "order.offering must've been already saved" unless record.offering.id
    raise "order.customer must've been already saved" unless record.customer.id

    super
  end

  def find_by_date(date)
    schema_class.where(date: date).map do |o|
      convert_to_object_and_set_id o
    end
  end

  def find_by_customer_id(customer_id)
    schema_class.where(customer_id: customer_id).map do |o|
      convert_to_object_and_set_id o
    end
  end

  private
    def hash_from_object(order)
      {
        date: order.date,
        customer_id: order.customer.id,
        offering_id: order.offering.id,
        note: order.note,
        state: order.state
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      offering = OfferingMapper.new.send :convert_to_object_and_set_id, order.offering

      Order.new(
        day: Day.new(date: order[:date]),
        offering: offering,
        customer: customer,
        note: order[:note],
        state: order[:state]
      )
    end

    def schema_class
      Schema::Order
    end
end
