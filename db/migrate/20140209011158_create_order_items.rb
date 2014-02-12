Sequel.migration do
  change do
    create_table :order_items do
      primary_key :id
      Integer :order_id, null: false
      Integer :offering_id, null: false
      Integer :position, null: false
    end
  end
end
