class Meal
  attr_accessor :name, :kitchen

  def initialize(attributes = {})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def offer!
    kitchen.add_meal self
  end
end
