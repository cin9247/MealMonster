class CustomerMapper < BaseMapper
  def save(record)
    if record.address
      AddressMapper.new.save(record.address)
    end

    super(record)
  end

  def update(record)
    if record.address
      if record.address.persisted?
        AddressMapper.new.update(record.address)
      else
        AddressMapper.new.save(record.address)
      end
    end

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
      address = AddressMapper.new.find(hash[:address_id])
      Customer.new(forename: hash[:forename],
                   surname:  hash[:surname],
                   address: address)
    end

    def schema_class
      Schema::Customer
    end
end
