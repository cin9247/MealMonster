Sequel.migration do
  change do
    alter_table :customers do
      add_column :email, String
    end
  end
end
