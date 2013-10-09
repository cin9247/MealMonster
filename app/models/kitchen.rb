class Kitchen
  attr_writer :meal_source, :menu_source, :day_source
  attr_writer :meal_mapper, :menu_mapper

  def new_meal(attributes={})
    meal_source.call(attributes).tap do |m|
      m.kitchen = self
    end
  end

  def new_menu(attributes={})
    meal_ids = attributes.delete(:meal_ids)

    menu_source.call(attributes).tap do |m|
      m.kitchen = self
      if meal_ids
        m.meals = meal_ids.map { |id| find_meal_by_id(id) }.compact
      end
    end
  end

  def add_meal(meal)
    if meal.persisted?
      meal_mapper.update meal
    else
      meal_mapper.save meal
    end
  end

  def add_menu(menu)
    menu_mapper.save menu
  end

  def day(date)
    day = if Date === date
      day_source.call date: date
    else
      day_source.call date: Date.parse(date)
    end
    day.kitchen = self
    day
  end

  def days(range)
    range.map { |date| day date }
  end

  def meals
    meal_mapper.fetch
  end

  def menus
    menu_mapper.fetch
  end

  def find_meal_by_id(id)
    meal_mapper.find(id.to_i).tap do |m|
      m && m.kitchen = self
    end
  end

  def find_menu_by_id(id)
    menu_mapper.find(id.to_i).tap do |m|
      m && m.kitchen = self
    end
  end

  private
    def meal_source
      @meal_source ||= Meal.public_method(:new)
    end

    def menu_source
      @menu_source ||= Menu.public_method(:new)
    end

    def day_source
      @day_source ||= Day.public_method(:new)
    end

    def meal_mapper
      @meal_mapper ||= MealMapper.new
    end

    def menu_mapper
      @menu_mapper ||= MenuMapper.new
    end
end
