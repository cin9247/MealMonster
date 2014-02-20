require_relative "./money"

class Invoice
  attr_accessor :month, :line_items

  def initialize(attributes={})
    attributes.each do |key, value|
      send "#{key}=", value
    end
  end

  def total_price
    line_items.reduce(Money.new) do |sum, li|
      sum + li.price
    end
  end

  def line_items
    @line_items ||= []
  end
end
