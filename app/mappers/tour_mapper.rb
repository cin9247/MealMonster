class TourMapper < BaseMapper
  def save(record)
    super record

    create_customers_mapping record

    record.id
  end

  def update(record)
    super record

    remove_customer_mappings record
    create_customers_mapping record

    record.id
  end

  def find_sparse(id)
    t = DB[:tours].where(id: id).first
    raise RecordNotFound.new if t.nil?
    driver = UserMapper.new.non_whiny_find t[:driver_id]

    Tour.new(id: t[:id], created_at: t[:created_at], updated_at: t[:updated_at], name: t[:name], customers: [], driver: driver)
  end

  def only_keep_ids(ids)
    DB[:tours].where(:id => ids).invert.delete
  end

  def hash_from_object(record)
    {
      name: record.name,
      driver_id: record.driver.try(:id)
    }
  end

  def object_from_hash(hash)
    ## TODO use database!
    customer_ids = Schema::CustomersTour.where(tour_id: hash[:id]).order(:position).map(&:customer_id)
    customers = CustomerMapper.new.find customer_ids

    driver = UserMapper.new.non_whiny_find hash[:driver_id]

    Tour.new name: hash[:name], customers: customers, driver: driver
  end

  private
    def schema_class
      Schema::Tour
    end

    def remove_customer_mappings(record)
      Schema::CustomersTour.where(tour_id: record.id).delete
    end

    def create_customers_mapping(record)
      record.customers.each_with_index do |c, i|
        r = Schema::CustomersTour.new customer_id: c.id, tour_id: record.id, position: i
        r.save
      end
    end
end
