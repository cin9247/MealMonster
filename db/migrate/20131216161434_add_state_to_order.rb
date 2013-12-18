Sequel.migration do
  change do
    alter_table :orders do
      add_column :state, String, null: false, default: "ordered"
    end
  end
end
