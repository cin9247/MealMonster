class Kitchen
  attr_writer :meal_source, :menu_source

  def new_meal(*args)
    meal_source.call self, *args
  end

  def new_menu(*args)
    menu_source.call self, *args
  end

  def add_meal(meal)
    meals << meal
  end

  def add_menu(menu)
    menus << menu
  end

  def clean_up!
    @meals = []
    @menus = []
  end

  def meals
    @meals ||= []
  end

  def menus
    @menus ||= []
  end

  def menu_for_day(day)
    menus.find do |m|
      m.date == day
    end
  end

  private
    def meal_source
      @meal_source ||= Meal.public_method(:new)
    end

    def menu_source
      @menu_source ||= Menu.public_method(:new)
    end
end
