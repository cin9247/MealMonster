Sequel.migration do
  change do
    alter_table :tickets do
      add_column :order_id, Integer
    end
  end
end
