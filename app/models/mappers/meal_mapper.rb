class MealMapper < BaseMapper
  private
    def object_to_hash(record)
      {
        name: record.name
      }
    end

    def hash_to_object(hash)
      Meal.new(KITCHEN,
        id: hash[:id],
        name: hash[:name]
      )
    end

    def table_name
      :meals
    end
end
