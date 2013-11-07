class MealMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name,
      bread_units: record.bread_units,
      kilojoules: record.kilojoules,
      price_class_id: record.price_class_id
    }
  end

  def object_from_hash(hash)
    price_class = PriceClassMapper.new.find hash[:price_class_id]
    Meal.new name: hash[:name],
             bread_units: hash[:bread_units],
             kilojoules: hash[:kilojoules],
             price_class: price_class
  end

  private
    def schema_class
      Schema::Meal
    end
end
