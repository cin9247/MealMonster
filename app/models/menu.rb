require 'active_model'

class Menu
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :meals, :kitchen, :date

  def initialize(kitchen=nil, attrs={})
    self.kitchen = kitchen

    self.attributes = attrs
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      public_send("#{key}=", value)
    end
  end

  def offer!
    kitchen.add_menu self
  end

  def meals
    @meals ||= []
  end

  def meal_ids
    meals.map(&:id)
  end

  def meal_ids=(ids)
    self.meals = ids.map do |id|
      kitchen.find_meal_by_id id
    end.compact
  end

  def persisted?
    !id.nil?
  end
end
