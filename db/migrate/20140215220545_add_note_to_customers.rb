Sequel.migration do
  change do
    alter_table :customers do
      add_column :note, String, text: true
    end
  end
end
