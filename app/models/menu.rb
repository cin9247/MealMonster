require 'active_model'

class Menu
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :meals, :kitchen, :name

  def initialize(attrs={})
    self.attributes = attrs
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def meals
    @meals ||= []
  end

  def meal_ids
    meals.map(&:id)
  end

  def persisted?
    !id.nil?
  end
end
