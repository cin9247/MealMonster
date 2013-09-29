class Menu
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :meals, :kitchen, :date

  def initialize(kitchen=nil, attrs={})
    self.kitchen = kitchen

    attrs.each do |key, value|
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
    ids = ids.reject(&:blank?).map(&:to_i)
    self.meals = kitchen.meals.select do |m|
      ids.include? m.id
    end
  end

  def persisted?
    false
  end
end
