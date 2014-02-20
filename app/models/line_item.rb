class LineItem
  attr_accessor :date, :name, :price

  def initialize(attributes={})
    attributes.each do |key, value|
      send "#{key}=", value
    end
  end
end
