class KeyMapper < BaseMapper
  def fetch_by_date_and_tour(date, tour_id)
    OrderMapper.new.fetch_by_date_and_tour(date, tour_id).map do |o|
      r = DB[:keys].where(address_id: o.customer.address.id).all
      r.map do |k|
        Key.new(id: k[:id], name: k[:name], customer_id: o.customer.id)
      end
    end.flatten
  end

  private
    def hash_from_object(object)
      { name: object.name }
    end

    def object_from_hash(hash)
      Key.new(id: hash[:id], name: hash[:name])
    end

    def schema_class
      Schema::Key
    end
end
