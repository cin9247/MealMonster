require 'active_model'

class Offering
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :menu, :day

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def date
    day && day.date
  end

  def meals
    menu.meals
  end
end
