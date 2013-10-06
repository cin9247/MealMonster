class BaseMapper
  def save(record)
    raise "Can't be saved again. Try #update instead" if record.id

    record.id = DB[table_name].insert object_to_hash(record)
  end

  def update(record)
    raise "Can't update non-existing record. Try #save instead" unless record.id

    DB[table_name].filter(id: record.id)
                  .update(object_to_hash(record))
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

  def object_to_hash(record)
    raise "Your mapper needs to implement `object_to_hash`."
  end

  def hash_to_object(record)
    raise "Your mapper needs to implement `hash_to_object`."
  end

  private
    def table_name
      raise "Your mapper needs to implement `table_name`"
    end

    def convert_to_object_and_set_id(hash)
      hash_to_object(hash).tap do |o|
        o.id = hash[:id]
      end
    end
end
