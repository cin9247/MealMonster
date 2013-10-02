class MealMapper < BaseMapper
  private
    def object_to_hash(record)
      {
        id: record.id,
        name: record.name
      }
    end

    def hash_to_object(hash)
      Meal.new(KITCHEN,
        id: hash["id"],
        name: hash["name"]
      )
    end

    def klass
      Class.new(ActiveRecord::Base) do
        self.table_name = "meals"
      end
    end
end
