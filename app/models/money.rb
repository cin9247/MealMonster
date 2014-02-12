class Money
  attr_reader :amount, :currency

  def initialize(amount=0, currency="EUR")
    @amount = amount
    @currency = currency
  end

  def +(other)
    Money.new(amount + other.amount, currency)
  end

  def to_s
    "%.2f" % (amount / 100.0) + " #{currency}"
  end

  def self.parse(input)
    input = input.strip
    input = input.gsub('€', '').strip
    splitted = input.split(/\.|,/)
    case splitted.length
    when 1 then Money.new(splitted.first.to_i * 100)
    when 2 then Money.new(splitted.first.to_i * 100 + (splitted.last.size > 1 ? splitted.last.strip[0..1].to_i : splitted.last.to_i * 10))
    else Money.new
    end
  end

  def ==(other)
    return false unless other.is_a? Money
    other.amount == self.amount && other.currency == self.currency
  end

  def self.zero
    self.new 0, "EUR"
  end
end
