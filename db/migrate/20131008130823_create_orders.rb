Sequel.migration do
  change do
    create_table :orders do
      primary_key :id
      Fixnum :menu_id, null: false
      Fixnum :customer_id, null: false
      Date :date, null: false
    end
  end
end
