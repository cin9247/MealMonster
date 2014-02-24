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

  def find_by_month_and_customer_id(month, customer_id)
    schema_class.where(date: month.to_date_range.to_range).where(customer_id: customer_id).order(:date).map do |o|
      convert_to_object_and_set_id o
    end
  end

  def find_by_customer_id(customer_id)
    schema_class.where(customer_id: customer_id).map do |o|
      convert_to_object_and_set_id o
    end
  end



  def fetch_by_date_and_tour(date, tour_id)
    DB["SELECT orders.*, customers.forename, customers.surname FROM orders, customers_tours, customers WHERE orders.date = ? AND customers_tours.tour_id = ? AND customers_tours.customer_id = orders.customer_id AND customers.id = orders.customer_id", date, tour_id].map do |o|
      a = Address.new(town: o[:town], postal_code: o[:postal_code], street_number: o[:street_number], street_name: o[:street_name])
      c = Customer.new(forename: o[:forename], surname: o[:surname], address: a)
      offering_ids = DB[:order_items].where(order_id: o[:id]).select(:offering_id).map { |o| o[:offering_id] }
      offerings = OfferingMapper.new.find(offering_ids)
      # TODO fix me

      Order.new customer: c, offerings: offerings, date: o[:date], note: o[:note], state: o[:state]
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
      if order.respond_to? :customer
        customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      else
        customer = CustomerMapper.new.find order[:customer_id]
      end
      offering_ids = DB[:order_items].where(order_id: order[:id]).select(:offering_id).map { |o| o[:offering_id] }
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
