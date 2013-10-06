class MealMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    Meal.new name: hash[:name]
  end

  private
    def table_name
      :meals
    end
end
