Sequel.migration do
  change do
    alter_table :meals do
      add_column :bread_units, Float
      add_column :kilojoules, Integer
    end
  end
end
