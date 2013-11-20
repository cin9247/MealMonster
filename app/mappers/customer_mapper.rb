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
      {
        forename: object.forename,
        surname:  object.surname,
        address_id: address_id
      }
    end

    def object_from_hash(hash)
      address = begin
        AddressMapper.new.find(hash[:address_id])
      rescue RecordNotFound
        nil
      end

      Customer.new(forename: hash[:forename],
                   surname:  hash[:surname],
                   address: address)
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
