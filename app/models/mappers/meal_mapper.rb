class MealMapper < BaseMapper
  def object_to_hash(record)
    {
      name: record.name
    }
  end

  def hash_to_object(hash)
    Meal.new name: hash[:name]
  end

  private
    def table_name
      :meals
    end
end
