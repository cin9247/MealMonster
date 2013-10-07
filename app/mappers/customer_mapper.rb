class CustomerMapper < BaseMapper
  private
    def hash_from_object(object)
      {
        forename: object.forename,
        surname:  object.surname
      }
    end

    def object_from_hash(hash)
      Customer.new(forename: hash[:forename],
                   surname:  hash[:surname])
    end

    def schema_class
      Schema::Customer
    end
end
