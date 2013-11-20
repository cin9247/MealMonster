class AddressMapper < BaseMapper
  private
    def hash_from_object(object)
      {
        town: object.town,
        postal_code: object.postal_code,
        street_name: object.street_name,
        street_number: object.street_number
      }
    end

    def object_from_hash(hash)
      Address.new(town: hash[:town],
                  postal_code: hash[:postal_code],
                  street_name: hash[:street_name],
                  street_number: hash[:street_number])
    end

    def schema_class
      Schema::Address
    end
end
