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
    schema_class.where(date: date).where(canceled: false).map do |o|
      convert_to_object_and_set_id o
    end
  end

  def find_by_month_and_customer_id(month, customer_id)
    find_by_customer_id_and_date_range(customer_id, month.to_date_range)
  end

  def find_by_customer_id_and_date_range(customer_id, date_range)
    schema_class.where(customer_id: customer_id).where{(date >= date_range.from) & (date <= date_range.to)}.where(canceled: false).order(:date).all.map do |o|
      convert_to_object_and_set_id o
    end
  end

  def fetch_by_date_and_tour(date, tour_id)
    DB["SELECT orders.*, customers.id AS customers_id, customers.forename, customers.surname, customers.address_id, customers.telephone_number, customers.note AS customer_note FROM orders, customers_tours, customers WHERE orders.canceled = false AND orders.date = ? AND customers_tours.tour_id = ? AND customers_tours.customer_id = orders.customer_id AND customers.id = orders.customer_id", date, tour_id].map do |o|
      a = AddressMapper.new.non_whiny_find(o[:address_id])
      c = Customer.new(id: o[:customer_id], forename: o[:forename], surname: o[:surname], address: a, note: o[:customer_note], telephone_number: o[:telephone_number])
      offering_ids = DB[:order_items].where(order_id: o[:id]).select(:offering_id).map { |o| o[:offering_id] }
      offerings = OfferingMapper.new.find(offering_ids)
      # TODO fix me

      Order.new customer: c, offerings: offerings, date: o[:date], note: o[:note], state: o[:state], id: o[:id]
    end
  end

  private
    def hash_from_object(order)
      {
        date: order.date,
        customer_id: order.customer.id,
        note: order.note,
        state: order.state,
        canceled: order.canceled?
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      offering_ids = DB[:order_items].where(order_id: order.id).select(:offering_id).map { |o| o[:offering_id] }
      offerings = OfferingMapper.new.find(offering_ids)

      result = Order.new(
        date: order[:date],
        offerings: offerings,
        customer: customer,
        note: order[:note],
        state: order[:state]
      )
      result.cancel! if order[:canceled]
      result
    end

    def schema_class
      Schema::Order
    end
end
