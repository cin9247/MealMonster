class Day
  attr_accessor :date
  attr_accessor :organization

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end
end
