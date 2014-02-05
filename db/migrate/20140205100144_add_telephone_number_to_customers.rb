Sequel.migration do
  change do
    alter_table :customers do
      add_column :telephone_number, String
    end
  end
end
