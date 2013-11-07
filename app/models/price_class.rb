class PriceClass
  attr_accessor :id, :name

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end
end
