require_relative "./money"

class Invoice
  attr_accessor :month, :line_items, :customer

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

  def total_count
    line_items.reduce(0) do |sum, li|
      sum + li.count
    end
  end

  def line_items
    @line_items ||= []
  end
end
