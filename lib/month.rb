require "date_range"

class Month
  attr_reader :month, :year

  def initialize(month, year)
    @month = month
    @year = year
  end

  def to_date_range
    DateRange.new(Date.new(year, month, 1), Date.new(year, month, -1))
  end

  def self.from_date date
    new date.month, date.year
  end
end
