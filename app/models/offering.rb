require 'active_model'

class Offering
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :menu, :day

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def date
    day && day.date
  end

  def date=(date)
    self.day = Day.new(date: date)
    date
  end

  def name
    menu.name
  end

  def meals
    menu.meals
  end

  def persisted?
    !id.nil?
  end

  def price
    Money.new(430, 'EUR')
  end
end
