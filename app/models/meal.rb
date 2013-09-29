class Meal
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :name, :kitchen

  def initialize(kitchen = nil, attributes = {})
    self.kitchen = kitchen

    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def offer!
    kitchen.add_meal self
  end

  def persisted?
    false
  end

  def id
    object_id
  end
end
