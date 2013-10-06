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

  def hash_from_object(record)
    ## TODO this looks weird, but might be filled with `name` later
    {}
  end

  def object_from_hash(hash)
    Menu.new
  end

  private
    def table_name
      :menus
    end

    def fetch_meals_for(menu)
      DB[:meals_menus].filter(menu_id: menu.id).join(:meals, :id => :meal_id).all.map do |meal|
        ## TODO rearrange code to not use dirty `send` hack
        MealMapper.new.send :convert_to_object_and_set_id, meal
      end
    end
end
