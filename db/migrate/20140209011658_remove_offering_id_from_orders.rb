Sequel.migration do
  up do
    alter_table :orders do
      drop_column :offering_id
    end
  end

  down do
    alter_table :orders do
      add_column :offering_id, :integer, null: false
    end
  end
end
