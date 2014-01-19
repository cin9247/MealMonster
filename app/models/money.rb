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
end
