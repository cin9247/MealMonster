class BaseMapper
  def save(record)
    raise "Can't be saved again. Try #update instead" if record.id

    record.id = schema_class.new(hash_from_object(record)).save[:id]
  end

  def update(record)
    raise "Can't update non-existing record. Try #save instead" unless record.id

    schema_class.where(id: record.id)
               .update(hash_from_object(record))
  end

  def fetch
    schema_class.all.map do |m|
      convert_to_object_and_set_id m
    end
  end

  def clean
    schema_class.dataset.delete
  end

  def find(id)
    result = schema_class[id]

    convert_to_object_and_set_id(result) if result
  end

  def hash_from_object(record)
    raise "Your mapper needs to implement `hash_from_object`."
  end

  def object_from_hash(hash)
    raise "Your mapper needs to implement `object_from_hash`."
  end

  private
    def schema_class
      raise "Your mapper needs to implement `schema_class`"
    end

    def convert_to_object_and_set_id(hash)
      object_from_hash(hash).tap do |o|
        o.id = hash[:id]
      end
    end
end
