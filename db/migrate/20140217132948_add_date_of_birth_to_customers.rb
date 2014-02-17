Sequel.migration do
  change do
    alter_table :customers do
      add_column :date_of_birth, Date
    end
  end
end
