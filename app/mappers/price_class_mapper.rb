class PriceClassMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    PriceClass.new name: hash[:name]
  end

  private
    def schema_class
      Schema::PriceClass
    end
end
