Sequel.migration do
  change do
    create_table :tours do
      primary_key :id
      String :name, null: false
    end
  end
end
