class MenuMapper < BaseMapper
  def save(record)
    menu_id = super(record)

    record.meals.each_with_index do |m, i|
      meal_id = if m.persisted?
        m.id
      else
        MealMapper.new.save(m)
      end

      DB[:meals_menus].insert menu_id: menu_id, meal_id: meal_id, position: i
    end

    menu_id
  end

  def fetch
    menus = super

    menus.each do |menu|
      menu.meals = fetch_meals_for(menu)
    end
  end

  def find(id)
    menu = super(id)
    return unless menu ## TODO move this check into fetch_meals_for?

    menu.meals = fetch_meals_for(menu)

    menu
  end

  def object_to_hash(record)
    {
      date: record.date
    }
  end

  def hash_to_object(hash)
    Menu.new(
      id: hash[:id],
      date: hash[:date]
    )
  end

  private
    def table_name
      :menus
    end

    def fetch_meals_for(menu)
      DB[:meals_menus].filter(menu_id: menu.id).join(:meals, :id => :meal_id).all.map do |meal|
        MealMapper.new.hash_to_object meal
      end
    end
end
