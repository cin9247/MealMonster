class Order
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :day, :offering, :customer

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def menu
    offering.menu
  end

  def place!
    day.add_order self
  end

  def customer_id
    customer && customer.id
  end

  def offering_id
    offering && offering.id
  end

  def persisted?
    !id.nil?
  end
end
