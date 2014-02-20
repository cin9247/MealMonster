class OrderMapper < BaseMapper
  def save(record)
    raise "order.offering must've been already saved" unless record.offerings.all?(&:id)
    raise "order.customer must've been already saved" unless record.customer.id

    id = nil
    DB.transaction do
      id = super
      record.offerings.each_with_index do |offering, i|
        DB[:order_items].insert(order_id: id, offering_id: offering.id, position: i)
      end
    end

    id
  end

  def find_by_date(date)
    schema_class.where(date: date).map do |o|
      convert_to_object_and_set_id o
    end
  end

  def find_by_month(month)
    schema_class.where(date: month.to_date_range.to_range).order(:date).map do |o|
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
        note: order.note,
        state: order.state
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      offering_ids = DB[:order_items].where(order_id: order.id).select(:offering_id).map { |o| o[:offering_id] }
      offerings = OfferingMapper.new.find(offering_ids)

      Order.new(
        date: order[:date],
        offerings: offerings,
        customer: customer,
        note: order[:note],
        state: order[:state]
      )
    end

    def schema_class
      Schema::Order
    end
end
