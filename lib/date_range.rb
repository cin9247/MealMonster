class DateRange
  attr_reader :from, :to

  def initialize(from, to)
    @from, @to = from, to
  end

  def self.parse(from, to)
    new Date.parse(from), Date.parse(to)
  end

  def self.next_week
    new Date.today, Date.today + 7.days
  end
end
