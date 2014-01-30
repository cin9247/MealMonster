require 'active_model'

class Tour
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :name, :customers, :stations, :driver

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def customers
    @customers || []
  end

  def eject_driver!
    self.driver = nil
  end
end
