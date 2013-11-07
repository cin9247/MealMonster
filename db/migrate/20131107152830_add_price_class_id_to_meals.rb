Sequel.migration do
  change do
    alter_table :meals do
      add_column :price_class_id, Integer
    end
  end
end
