Sequel.migration do
  change do
    create_table :price_classes do
      primary_key :id
      String :name, null: false
    end
  end
end
