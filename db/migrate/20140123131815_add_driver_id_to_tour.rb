Sequel.migration do
  change do
    alter_table :tours do
      add_column :driver_id, Integer
    end
  end
end
