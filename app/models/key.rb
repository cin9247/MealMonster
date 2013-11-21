class Key
  attr_accessor :id, :name, :address

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def persisted?
    !id.nil?
  end
end
