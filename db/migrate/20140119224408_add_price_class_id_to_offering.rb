Sequel.migration do
  change do
    alter_table :offerings do
      add_column :price_class_id, Integer, null: false
    end
  end
end
