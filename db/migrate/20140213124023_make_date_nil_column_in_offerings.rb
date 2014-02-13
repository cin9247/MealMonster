Sequel.migration do
  up do
    alter_table :offerings do
      set_column_allow_null :date
    end
  end

  down do
    alter_table :offerings do
      set_column_not_null :date
    end
  end
end
