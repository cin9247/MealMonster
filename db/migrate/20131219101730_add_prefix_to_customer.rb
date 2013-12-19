Sequel.migration do
  change do
    alter_table :customers do
      add_column :prefix, String
    end
  end
end
