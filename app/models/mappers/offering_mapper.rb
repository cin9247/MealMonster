class OfferingMapper < BaseMapper
  def save(offering)
    ## TODO crashes if offering is already present, but this implies the presence of a menu, so we're fine?
    if !offering.menu.id
      MenuMapper.new.save offering.menu
    end

    super
  end

  def fetch_by_date(date)
    fetch.select do |o|
      o.date == date
    end
  end

  def object_to_hash(object)
    {
      date: object.date,
      menu_id: object.menu.id
    }
  end

  def hash_to_object(hash)
    menu = MenuMapper.new.find hash[:menu_id]
    Offering.new(date: hash[:date],
                 menu: menu)
  end

  def table_name
    :offerings
  end
end
