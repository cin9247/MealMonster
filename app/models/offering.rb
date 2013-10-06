class Offering
  attr_accessor :id, :menu, :date, :day

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value if respond_to? "#{key}="
    end
  end

  def date
    @date ||= day.date
  end
end
