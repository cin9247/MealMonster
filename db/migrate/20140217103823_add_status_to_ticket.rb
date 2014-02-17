Sequel.migration do
  change do
    alter_table :tickets do
      add_column :status, String, null: false
    end
  end
end
