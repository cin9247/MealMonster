class OfferingMapper < BaseMapper
  def save(offering)
    ## TODO crashes if offering is already present, but this implies the presence of a menu, so we're fine?
    if !offering.menu.id
      MenuMapper.new.save offering.menu
    end

    super
  end

  def fetch_by_date(date)
    schema_class.where(date: date).all.map do |o|
      convert_to_object_and_set_id o
    end
  end

  def hash_from_object(object)
    {
      date: object.date,
      menu_id: object.menu.id
    }
  end

  def object_from_hash(hash)
    menu = MenuMapper.new.find hash[:menu_id]
    Offering.new(date: hash[:date],
                 menu: menu)
  end

  private
    def schema_class
      Schema::Offering
    end
end
