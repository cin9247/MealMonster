require "active_model"

class AllTimeOffering
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :price_class, :id, :menu, :created_at, :updated_at

  def initialize(attributes={})
    attributes.each do |key, value|
      self.send "#{key}=", value
    end
  end

  def name
    menu.try(:name)
  end

  def price_class_id
    price_class && price_class.id
  end

  def price
    price_class.price
  end

  def persisted?
    !id.nil?
  end
end
