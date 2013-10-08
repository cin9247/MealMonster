class OrderMapper < BaseMapper
  def save(record)
    raise "order.menu must've been already saved" unless record.menu.id
    raise "order.customer must've been already saved" unless record.menu.id

    super
  end

  private
    def hash_from_object(order)
      {
        date: order.day.date,
        customer_id: order.customer.id,
        menu_id: order.menu.id
      }
    end

    def object_from_hash(order)
      customer = CustomerMapper.new.send :convert_to_object_and_set_id, order.customer
      menu = MenuMapper.new.send :convert_to_object_and_set_id, order.menu
      meals = order.menu.meals.each do |m|
        MealMapper.new.send :convert_to_object_and_set_id, m
      end
      menu.meals = meals

      ## TODO day creation??? which day if we have several?
      Order.new day: Day.new(date: order[:date]), menu: menu, customer: customer
    end

    def schema_class
      Schema::Order
    end
end
