class Address
  attr_accessor :id, :street_name, :street_number, :postal_code, :town
  attr_writer :keys

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def keys
    @keys ||= []
  end

  def add_key(key)
    keys << key
    key.address = self
  end

  def persisted?
    !id.nil?
  end
end
