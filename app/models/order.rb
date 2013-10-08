class Order
  attr_accessor :id, :day, :menu, :customer

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
    end
  end

  def place!
    day.add_order self
  end
end
