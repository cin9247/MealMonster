class DateRange
  attr_reader :from, :to

  def initialize(from, to)
    @from, @to = from, to
  end

  def first
    @from
  end

  def last
    @to
  end

  def to_a
    (@from..@to).to_a
  end

  def self.parse(from, to)
    new Date.parse(from), Date.parse(to)
  end

  def self.next_week
    new Date.today.next_week(:monday), Date.today.next_week(:sunday)
  end

  def self.this_week
    new Date.today.beginning_of_week, Date.today.end_of_week
  end
end
