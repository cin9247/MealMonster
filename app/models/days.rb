class Days
  attr_writer :offering_mapper
  attr_writer :day_source
  attr_accessor :organization
  attr_accessor :from, :to

  def initialize(attributes={})
    attributes.each do |key, value|
      public_send "#{key}=", value
    end
  end

  def offerings
    offering_mapper.fetch_by_date_range from, to
  end

  def each
    (from..to).each do |date|
      day = day_source.call date: date
      yield day
    end
  end

  private
    def offering_mapper
      @offering_mapper ||= OfferingMapper.new
    end

    def day_source
      @day_source ||= Day.public_method(:new)
    end
end
