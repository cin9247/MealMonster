require "active_model"

class Ticket
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :title, :body, :customer

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
    @status = :open
  end

  def closed?
    @status == :closed
  end

  def open?
    @status == :open
  end

  def close!
    @status = :closed
  end

  def reopen!
    @status = :open
  end

  def customer_id
    customer && customer.id
  end

  def persisted?
    !id.nil?
  end
end
