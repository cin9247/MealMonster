Sequel.migration do
  change do
    create_table :customers_tours do
      primary_key :id
      Integer :customer_id, null: false
      Integer :tour_id, null: false
      Integer :position, null: false
    end
  end
end
