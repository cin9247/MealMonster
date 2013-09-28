class Kitchen
  attr_writer :meal_source

  def new_meal(*args)
    meal_source.call(*args).tap do |m|
      m.kitchen = self
    end
  end

  def add_meal(meal)
    meals << meal
  end

  def clean_up!
    @meals = []
  end

  def meals
    @meals ||= []
  end

  private
    def meal_source
      @meal_source ||= Meal.public_method(:new)
    end
end
