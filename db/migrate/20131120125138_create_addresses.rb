Sequel.migration do
  change do
    create_table :addresses do
      primary_key :id
      String :street_name
      String :street_number
      String :postal_code, null: false
      String :town, null: false
    end
  end
end
