require 'active_model'

class Customer
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :organization, :prefix, :forename, :surname, :address

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
end
