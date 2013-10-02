class BaseMapper
  def save(record)
    klass.create object_to_hash(record)
  end

  def fetch
    klass.all.map do |m|
      hash_to_object(m.attributes)
    end
  end

  def clean
    klass.delete_all
  end

  def find(id)
    klass.find id
  rescue ActiveRecord::RecordNotFound
    nil
  end

  private
    def klass
      raise "Your mapper needs to implement `klass`"
    end

    def object_to_hash(record)
      raise "Your mapper needs to implement `object_to_hash`."
    end

    def hash_to_object(record)
      raise "Your mapper needs to implement `hash_to_object`."
    end
end
