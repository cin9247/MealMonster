Sequel.migration do
  change do
    alter_table :menus do
      add_column :name, String
    end
  end
end
