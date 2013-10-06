Sequel.migration do
  change do

    create_table :offerings do
      primary_key :id
      Date :date, null: false
      Fixnum :menu_id, null: false
    end

  end
end
