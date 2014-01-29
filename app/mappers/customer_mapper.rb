class CustomerMapper < BaseMapper
  def save(record)
    maybe_save_or_update record.address

    super(record)
  end

  def update(record)
    maybe_save_or_update record.address

    super(record)
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
        catchment_area_id: catchment_area_id
      }
    end

    def object_from_hash(hash)
      address = begin
        AddressMapper.new.find(hash[:address_id])
      rescue RecordNotFound
        nil
      end

      catchment_area = begin
        CatchmentAreaMapper.new.find(hash[:catchment_area_id])
      rescue RecordNotFound
        nil
      end

      Customer.new(forename: hash[:forename],
                   surname:  hash[:surname],
                   prefix:   hash[:prefix],
                   address: address,
                   catchment_area: catchment_area)
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
