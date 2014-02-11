require "active_model"

class Order
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :day, :offerings, :customer, :note, :date
  attr_reader :state

  def initialize(attributes={})
    @state = attributes.delete(:state) || "ordered"
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def menu
    offering.try(:menu)
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

  def offering_id
    offerings && offerings.first.id
  end

  def offering
    offerings.first
  end

  def date
    @date || offering.try(:date)
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
end
