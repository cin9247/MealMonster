Sequel.migration do
  change do
    create_table :keys do
      primary_key :id
      String :name, null: false
      Integer :address_id, null: false
    end
  end
end
