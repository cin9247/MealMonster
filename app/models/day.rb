class Day
  attr_accessor :date
  attr_writer :offering_mapper, :order_mapper, :offering_source, :order_source
  attr_accessor :kitchen, :organization

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def new_offering(attributes={})
    offering_source.call(attributes).tap do |o|
      o.day = self
    end
  end

  def offer!(menu)
    offering_mapper.save new_offering(menu: menu)
  end

  def new_order(attributes={})
    order_source.call(attributes).tap do |o|
      o.day = self
    end
  end

  def add_order(order)
    order_mapper.save order
  end

  def offerings
    offering_mapper.fetch_by_date date
  end

  def menus
    offerings.map(&:menu)
  end

  private
    def offering_mapper
      @offering_mapper ||= OfferingMapper.new
    end

    def order_mapper
      @order_mapper ||= OrderMapper.new
    end

    def offering_source
      @offering_source ||= Offering.public_method(:new)
    end

    def order_source
      @order_source ||= Order.public_method(:new)
    end
end
