class BaseMapper
  def save(record)
    raise "Can't be saved again. Try #update instead" if record.id

    record.id = DB[table_name].insert hash_from_object(record)
  end

  def update(record)
    raise "Can't update non-existing record. Try #save instead" unless record.id

    DB[table_name].filter(id: record.id)
                  .update(hash_from_object(record))
  end

  def fetch
    DB[table_name].all.map do |m|
      convert_to_object_and_set_id m
    end
  end

  def clean
    DB[table_name].delete
  end

  def find(id)
    result = DB[table_name].filter(id: id).first

    convert_to_object_and_set_id(result) if result
  end

  def hash_from_object(record)
    raise "Your mapper needs to implement `hash_from_object`."
  end

  def object_from_hash(hash)
    raise "Your mapper needs to implement `object_from_hash`."
  end

  private
    def table_name
      raise "Your mapper needs to implement `table_name`"
    end

    def convert_to_object_and_set_id(hash)
      object_from_hash(hash).tap do |o|
        o.id = hash[:id]
      end
    end
end
