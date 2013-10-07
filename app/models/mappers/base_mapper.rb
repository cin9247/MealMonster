class BaseMapper
  def save(record)
    raise "Can't be saved again. Try #update instead" if record.id

    record.id = model_class.new(hash_from_object(record)).save[:id]
  end

  def update(record)
    raise "Can't update non-existing record. Try #save instead" unless record.id

    model_class.where(id: record.id)
               .update(hash_from_object(record))
  end

  def fetch
    model_class.all.map do |m|
      convert_to_object_and_set_id m
    end
  end

  def clean
    model_class.dataset.delete
  end

  def find(id)
    result = model_class[id]

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

    def model_class
      @model_class ||= Class.new(Sequel::Model(table_name)) do
      end
    end
end
