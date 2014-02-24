class AddressMapper < BaseMapper
  def save(record)
    super record
    save_keys record
    record.id
  end

  def update(record)
    super record
    save_keys record
    record.id
  end

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
      keys = (hash.keys || []).map do |k|
        KeyMapper.new.send :convert_to_object_and_set_id, k
      end

      Address.new(town: hash[:town],
                  postal_code: hash[:postal_code],
                  street_name: hash[:street_name],
                  street_number: hash[:street_number],
                  keys: keys)
    end

    def schema_class
      Schema::Address
    end

    def save_keys(record)
      record.keys.each do |key|
        if key.persisted?
          DB[:keys].filter(id: key.id).update(address_id: record.id, name: key.name)
        else
          key.id = DB[:keys].insert address_id: record.id, name: key.name
        end
      end
    end
end
