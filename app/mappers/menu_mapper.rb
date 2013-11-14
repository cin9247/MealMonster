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
    menus_from_schema = Schema::Menu.all

    menus_from_schema.map do |m|
      convert_to_object_and_set_id(m).tap do |menu|
        menu.meals = fetch_meals_for(m)
      end
    end
  end

  def find(id)
    menu_from_schema = schema_class[id]

    return unless menu_from_schema

    menu = convert_to_object_and_set_id(menu_from_schema)

    menu.meals = fetch_meals_for(menu_from_schema)

    menu
  end

  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    Menu.new name: hash[:name]
  end

  private
    def schema_class
      Schema::Menu
    end

    def fetch_meals_for(menu_from_schema)
      menu_from_schema.meals.map do |m|
        MealMapper.new.send :convert_to_object_and_set_id, m
      end
    end
end
