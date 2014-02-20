require "active_model"
require_relative "./money"

class Order
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :day, :offerings, :customer, :note, :date, :created_at, :updated_at
  attr_reader :state

  def initialize(attributes={})
    @state = attributes.delete(:state) || "ordered"
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def deliver!
    @state = "delivered"
  end

  def load!
    @state = "loaded"
  end

  def customer_id
    customer && customer.id
  end

  def delivered?
    @state == "delivered"
  end
  alias_method :delivered, :delivered?

  def loaded?
    @state == "loaded"
  end
  alias_method :loaded, :loaded?

  def persisted?
    !id.nil?
  end

  def price
    offerings.reduce(Money.zero) { |sum, of| sum + of.price }
  end

  def valid?
    offerings.size > 0
  end

  def offerings
    @offerings ||= []
  end
end
