class Order
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :day, :menu, :customer

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def place!
    day.add_order self
  end

  def customer_id
    customer && customer.id
  end

  def menu_id
    menu && menu.id
  end

  def persisted?
    !id.nil?
  end
end
