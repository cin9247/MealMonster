Sequel.migration do
  change do
    alter_table :orders do
      add_column :note, String
    end
  end
end
