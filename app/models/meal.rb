require 'active_model'

class Meal
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :id, :name, :kitchen

  def initialize(attributes = {})
    self.attributes = attributes
  end

  def attributes=(attributes)
    attributes.each do |key, value|
      public_send "#{key}=", value if respond_to? "#{key}="
    end
  end

  def offer!
    kitchen.add_meal self
  end

  def persisted?
    !id.nil?
  end
end
