class TourMapper < BaseMapper
  def save(record)
    super record

    create_customers_mapping record

    record.id
  end

  def update(record)
    super record

    create_customers_mapping record

    record.id
  end

  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    ## TODO use database!
    customer_ids = Schema::CustomersTour.where(tour_id: hash[:id]).order(:position).map(&:customer_id)
    customers = CustomerMapper.new.find customer_ids

    Tour.new name: hash[:name], customers: customers
  end

  private
    def schema_class
      Schema::Tour
    end

    def create_customers_mapping(record)
      record.customers.each_with_index do |c, i|
        r = Schema::CustomersTour.new customer_id: c.id, tour_id: record.id, position: i
        r.save
      end
    end
end
