class PriceClass
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  attr_accessor :id, :name, :price

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def name_and_price
    "#{name} (#{price})"
  end

  def persisted?
    !id.nil?
  end
end
