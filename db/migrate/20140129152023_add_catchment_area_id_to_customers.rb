Sequel.migration do
  change do
    alter_table :customers do
      add_column :catchment_area_id, Integer
    end
  end
end
