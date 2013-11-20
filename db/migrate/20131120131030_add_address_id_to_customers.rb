Sequel.migration do
  change do
    alter_table :customers do
      add_column :address_id, Integer
    end
  end
end
