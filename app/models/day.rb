class Day
  attr_accessor :date
  attr_writer :offering_mapper, :order_mapper, :offering_source, :order_source
  attr_accessor :organization, :offerings

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def new_offering(attributes={})
    offering_source.call(attributes).tap do |o|
      o.day = self
      ## TODO remove this hack which is here to satisfy bad spec setup.
      ## How to fix: raise error here and get rid of all bad test setup
      o.price_class = PriceClassMapper.new.find(1)
    end
  end

  def offer!(menu)
    new_offering(menu: menu).tap do |o|
      offering_mapper.save o
    end
  end

  def new_order(attributes={})
    order_source.call(attributes).tap do |o|
      o.day = self
    end
  end

  def add_order(order)
    order_mapper.save order
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
