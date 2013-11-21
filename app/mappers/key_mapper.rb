class KeyMapper < BaseMapper
  private
    def hash_from_object(object)
      { name: object.name }
    end

    def object_from_hash(hash)
      Key.new(name: hash[:name])
    end

    def schema_class
      Schema::Key
    end
end
