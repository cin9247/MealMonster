Sequel.migration do
  change do
    [:addresses, :catchment_areas, :customers, :customers_tours, :keys, :meals, :meals_menus, :menus, :offerings, :order_items, :orders, :price_classes, :tickets, :tours, :users].each do |table|
      alter_table(table) do
        add_column :created_at, DateTime, null: false, default: DateTime.now.utc
        add_column :updated_at, DateTime, null: false, default: DateTime.now.utc
      end
    end
  end
end
