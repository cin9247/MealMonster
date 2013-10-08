class Organization
  attr_writer :customer_source, :customer_mapper, :order_mapper, :kitchen_source, :day_source

  def new_customer(options={})
    customer_source.call(options).tap do |c|
      c.organization = self
    end
  end

  def customers
    customer_mapper.fetch
  end

  def orders
    order_mapper.fetch
  end

  def add_customer(c)
    customer_mapper.save c
  end

  def find_customer_by_id(id)
    customer_mapper.find id
  end

  def day(date)
    day = if Date === date
      day_source.call date: date
    else
      day_source.call date: Date.parse(date)
    end
    day.organization = self
    day
  end

  def kitchen
    @kitchen ||= kitchen_source.call
  end

  private
    def customer_source
      @customer_source ||= Customer.public_method(:new)
    end

    def customer_mapper
      @customer_mapper ||= CustomerMapper.new
    end

    def kitchen_source
      @kitchen_source ||= Kitchen.public_method(:new)
    end

    def day_source
      @day_source ||= Day.public_method(:new)
    end

    def order_mapper
      @order_mapper ||= OrderMapper.new
    end
end
