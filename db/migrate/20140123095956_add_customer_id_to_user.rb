Sequel.migration do
  change do
    alter_table :users do
      add_column :customer_id, Integer
    end
  end
end
