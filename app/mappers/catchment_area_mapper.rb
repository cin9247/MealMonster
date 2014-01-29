class CatchmentAreaMapper < BaseMapper
  def hash_from_object(record)
    {
      name: record.name
    }
  end

  def object_from_hash(hash)
    CatchmentArea.new(
      name: hash[:name]
    )
  end

  private
    def schema_class
      Schema::CatchmentArea
    end
end
