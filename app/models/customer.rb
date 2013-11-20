require 'active_model'

class Customer
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :organization, :forename, :surname, :address

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def full_name
    "#{forename} #{surname}"
  end

  def persisted?
    !id.nil?
  end

  def town
    address.try(:town)
  end

  def street_name
    address.try(:street_name)
  end
end
