require 'active_model'

class Tour
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :id, :name, :customers

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end
end