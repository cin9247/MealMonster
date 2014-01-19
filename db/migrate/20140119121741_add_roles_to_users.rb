Sequel.migration do
  change do
    alter_table :users do
      add_column :roles, :text, null: false
    end
  end
end
