require "date_range"

class Month
  attr_reader :month, :year

  def initialize(year, month)
    @month = month
    @year = year
  end

  def to_date_range
    DateRange.new(Date.new(year, month, 1), Date.new(year, month, -1))
  end

  def next
    if month == 12
      Month.new year + 1, 1
    else
      Month.new year, month + 1
    end
  end

  def previous
    if month == 1
      Month.new year - 1, 12
    else
      Month.new year, month - 1
    end
  end

  def first_day
    Date.new(year, month, 1)
  end

  def self.from_date date
    new date.year, date.month
  end
end
