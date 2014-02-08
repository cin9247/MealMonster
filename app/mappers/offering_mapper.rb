class OfferingMapper < BaseMapper
  def save(offering)
    ## TODO crashes if offering is already present, but this implies the presence of a menu, so we're fine?
    if !offering.menu.id
      MenuMapper.new.save offering.menu
    end

    super
  end

  def fetch_by_date(date)
    schema_class.eager(:menu => :meals).where(date: date).all.map do |o|
      convert_to_object_and_set_id o
    end
  end

  def fetch_by_date_range(from, to)
    schema_class.eager(:menu => :meals).where(date: from..to).all.map do |o|
      convert_to_object_and_set_id o
    end
  end

  def hash_from_object(object)
    ## TODO don't depend on price_class
    {
      date: object.date,
      menu_id: object.menu.id,
      price_class_id: object.price_class.id
    }
  end

  def object_from_hash(hash)
    meals = hash.menu.meals.map do |m|
      MealMapper.new.send(:convert_to_object_and_set_id, m)
    end
    menu = MenuMapper.new.send(:convert_to_object_and_set_id, hash.menu)
    menu.meals = meals
    day = Day.new(date: hash[:date])

    price_class = PriceClassMapper.new.find(hash[:price_class_id])

    Offering.new(day: day,
                 menu: menu,
                 price_class: price_class)
  end

  private
    def schema_class
      Schema::Offering
    end
end
