Sequel.migration do
  change do
    alter_table :customers do
      add_column :deleted_at, DateTime
    end
  end
end
