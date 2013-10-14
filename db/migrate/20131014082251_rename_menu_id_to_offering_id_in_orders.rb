Sequel.migration do
  up do
    alter_table :orders do
      rename_column :menu_id, :offering_id
    end
  end

  down do
    alter_table :orders do
      rename_column :offering_id, :menu_id
    end
  end
end
