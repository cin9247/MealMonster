class TourMapper < BaseMapper
  def save(record)
    super(record)

    record.customers.each_with_index do |c, i|
      r = Schema::CustomersTour.new customer_id: c.id, tour_id: record.id, position: i
      r.save
    end

    record.id
  end

  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    customers = Schema::Tour[hash[:id]].customers.map do |c|
      CustomerMapper.new.send :convert_to_object_and_set_id, c
    end
    Tour.new name: hash[:name], customers: customers
  end

  private
    def schema_class
      Schema::Tour
    end
end
