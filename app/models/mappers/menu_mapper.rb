class MenuMapper < BaseMapper
  private
    def object_to_hash(record)
      {
        date: record.date
      }
    end

    def hash_to_object(hash)
      Menu.new(KITCHEN,
        id: hash[:id],
        date: hash[:date]
      )
    end

    def table_name
      :menus
    end
end
