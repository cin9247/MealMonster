class BaseMapper
  def save(record)
    record.id = DB[table_name].insert object_to_hash(record)
  end

  def fetch
    DB[table_name].all.map do |m|
      hash_to_object(m)
    end
  end

  def clean
    DB[table_name].delete
  end

  def find(id)
    result = DB[table_name].filter(id: id).first
    hash_to_object(result) if result
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
end
