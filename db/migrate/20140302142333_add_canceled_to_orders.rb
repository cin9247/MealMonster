Sequel.migration do
  change do
    alter_table :orders do
      add_column :canceled, :boolean, null: false, default: false
    end
  end
end
