class Address
  attr_accessor :id, :street_name, :street_number, :postal_code, :town

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def persisted?
    !id.nil?
  end
end
