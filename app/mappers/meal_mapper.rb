class MealMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name,
      bread_units: record.bread_units,
      kilojoules: record.kilojoules
    }
  end

  def object_from_hash(hash)
    Meal.new name: hash[:name],
             bread_units: hash[:bread_units],
             kilojoules: hash[:kilojoules]
  end

  private
    def schema_class
      Schema::Meal
    end
end
