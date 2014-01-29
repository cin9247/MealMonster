Sequel.migration do
  change do
    create_table :catchment_areas do
      primary_key :id
      String :name, null: false
    end
  end
end
