class MenuMapper < BaseMapper
  private
    def object_to_hash(record)
      {
        id: record.id,
        date: record.date
      }
    end

    def hash_to_object(hash)
      Menu.new(KITCHEN,
        id: hash["id"],
        date: hash["date"]
      )
    end

    def klass
      Class.new(ActiveRecord::Base) do
        self.table_name = "menus"
      end
    end
end
