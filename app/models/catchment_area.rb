class CatchmentArea
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  attr_accessor :id, :name, :created_at, :updated_at

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def persisted?
    !id.nil?
  end
end
