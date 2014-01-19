class PriceClassMapper < BaseMapper
  def fetch
    [
      PriceClass.new(id: 1, name: "Preisklasse 1", price: Money.new(741)),
      PriceClass.new(id: 2, name: "Preisklasse 2", price: Money.new(438)),
      PriceClass.new(id: 3, name: "Frühstück", price: Money.new(640))
    ]
  end

  def find(id)
    fetch.find { |p| p.id == id }
  end
end
