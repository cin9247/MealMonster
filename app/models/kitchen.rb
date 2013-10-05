class Kitchen
  attr_writer :meal_source, :menu_source
  attr_writer :meal_mapper, :menu_mapper

  def new_meal(attributes={})
    meal_source.call(attributes).tap do |m|
      m.kitchen = self
    end
  end

  def new_menu(attributes={})
    menu_source.call(attributes).tap do |m|
      m.kitchen = self
      if attributes[:meal_ids]
        m.meals = attributes[:meal_ids].map { |id| find_meal_by_id(id) }.compact
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

  def clean_up!
    meal_mapper.clean
    menu_mapper.clean
  end

  def meals
    meal_mapper.fetch
  end

  def menus
    menu_mapper.fetch
  end

  def menu_for_day(day)
    menus.find do |m|
      m.date == day
    end
  end

  def find_meal_by_id(id)
    meal_mapper.find(id.to_i).tap do |m|
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

    def meal_mapper
      @meal_mapper ||= MealMapper.new
    end

    def menu_mapper
      @menu_mapper ||= MenuMapper.new
    end
end
