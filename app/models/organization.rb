class Organization
  attr_writer :customer_source, :customer_mapper

  def new_customer(options={})
    customer_source.call(options).tap do |c|
      c.organization = self
    end
  end

  def customers
    customer_mapper.fetch
  end

  def add_customer(c)
    customer_mapper.save c
  end

  private
    def customer_source
      @customer_source ||= Customer.public_method(:new)
    end

    def customer_mapper
      @customer_mapper ||= CustomerMapper.new
    end
end
