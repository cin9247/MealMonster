class MealMapper
  def save(record)
    meals << record
  end

  def fetch
    meals
  end

  def clean
    @meals = []
  end

  def find(id)
    fetch.find do |m|
      m.id == id
    end
  end

  private
    def meals
      @meals ||= []
    end
end
