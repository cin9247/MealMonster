require 'active_model'

class Customer
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion

  attr_accessor :id, :organization, :forename, :surname

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value if respond_to? "#{key}="
    end
  end

  def subscribe!
    organization.add_customer self
  end

  def full_name
    "#{forename} #{surname}"
  end

  def persisted?
    !id.nil?
  end
end
