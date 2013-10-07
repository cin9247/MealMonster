require 'active_model'

class Menu
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :meals, :kitchen, :date

  def initialize(attrs={})
    self.attributes = attrs
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      public_send("#{key}=", value) if respond_to? "#{key}="
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

  def persisted?
    !id.nil?
  end
end
