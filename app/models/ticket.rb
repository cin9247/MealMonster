require "active_model"

class Ticket
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :title, :body, :customer, :order

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def status
    :open
  end

  def customer_id
    customer && customer.id
  end

  def persisted?
    !id.nil?
  end
end
