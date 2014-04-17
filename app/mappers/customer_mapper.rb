class CustomerMapper < BaseMapper
  def save(record)
    maybe_save_or_update record.address

    super(record)
  end

  def update(record)
    maybe_save_or_update record.address

    super(record)
  end

  def delete(record)
    schema_class[record.id].update(deleted_at: DateTime.now)
    DB[:customers_tours].where(customer_id: record.id).delete
  end

  def fetch
    schema_class.where(:deleted_at => nil).eager(:address => :keys).eager(:catchment_area).order(Sequel.function(:lower, :surname)).all.map do |c|
      convert_to_object_and_set_id c
    end
  end

  private
    def hash_from_object(object)
      address_id = object.address.id if object.address
      catchment_area_id = object.catchment_area.id if object.catchment_area
      {
        forename: object.forename,
        surname:  object.surname,
        prefix:   object.prefix,
        address_id: address_id,
        catchment_area_id: catchment_area_id,
        telephone_number: object.telephone_number,
        note: object.note,
        date_of_birth: object.date_of_birth,
        email: object.email
      }
    end

    def object_from_hash(hash)
      address = hash.address ? AddressMapper.new.send(:convert_to_object_and_set_id, hash.address) : nil

      catchment_area = hash.catchment_area ? CatchmentAreaMapper.new.send(:convert_to_object_and_set_id, hash.catchment_area) : nil

      Customer.new(forename: hash[:forename],
                   surname:  hash[:surname],
                   prefix:   hash[:prefix],
                   telephone_number: hash[:telephone_number],
                   address: address,
                   catchment_area: catchment_area,
                   note: hash[:note],
                   date_of_birth: hash[:date_of_birth],
                   email: hash[:email]
                  )
    end

    def schema_class
      Schema::Customer
    end

    def maybe_save_or_update(address)
      return unless address

      if address.persisted?
        AddressMapper.new.update address
      else
        AddressMapper.new.save address
      end
    end
end
