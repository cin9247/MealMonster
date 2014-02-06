Sequel.migration do
  change do
    alter_table :tickets do
      add_column :customer_id, Integer, null: false
    end
  end
end
