Sequel.migration do
  change do
    create_table(:addresses) do
      primary_key :id
      column :street_name, "text"
      column :street_number, "text"
      column :postal_code, "text", :null=>false
      column :town, "text", :null=>false
    end

    create_table(:catchment_areas) do
      primary_key :id
      column :name, "text", :null=>false
    end

    create_table(:customers) do
      primary_key :id
      column :forename, "text"
      column :surname, "text"
      column :address_id, "integer"
      column :prefix, "text"
      column :catchment_area_id, "integer"
      column :telephone_number, "text"
    end

    create_table(:customers_tours) do
      primary_key :id
      column :customer_id, "integer", :null=>false
      column :tour_id, "integer", :null=>false
      column :position, "integer", :null=>false
    end

    create_table(:keys) do
      primary_key :id
      column :name, "text", :null=>false
      column :address_id, "integer", :null=>false
    end

    create_table(:meals) do
      primary_key :id
      column :name, "text", :null=>false
      column :bread_units, "double precision"
      column :kilojoules, "integer"
    end

    create_table(:meals_menus) do
      primary_key :id
      column :menu_id, "integer", :null=>false
      column :meal_id, "integer", :null=>false
      column :position, "integer", :null=>false
    end

    create_table(:menus) do
      primary_key :id
      column :name, "text"
    end

    create_table(:offerings) do
      primary_key :id
      column :date, "date", :null=>false
      column :menu_id, "integer", :null=>false
      column :price_class_id, "integer", :null=>false
    end

    create_table(:orders) do
      primary_key :id
      column :offering_id, "integer", :null=>false
      column :customer_id, "integer", :null=>false
      column :date, "date", :null=>false
      column :note, "text"
      column :state, "text", :default=>"ordered", :null=>false
    end

    create_table(:price_classes) do
      primary_key :id
      column :name, "text", :null=>false
      column :amount, "integer", :null=>false
    end

    create_table(:schema_migrations) do
      column :filename, "text", :null=>false

      primary_key [:filename]
    end

    create_table(:tours) do
      primary_key :id
      column :name, "text", :null=>false
      column :driver_id, "integer"
    end

    create_table(:users) do
      primary_key :id
      column :name, "text", :null=>false
      column :password_digest, "text", :null=>false
      column :roles, "text", :null=>false
      column :customer_id, "integer"
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131002124017_create_meals.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131002134404_create_menu.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131003165711_create_meals_menus.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131006160112_create_offerings.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131007140110_create_customers.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131007203048_add_bread_units_and_kilojoules_to_meals.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131008130823_create_orders.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131009151739_add_name_to_menus.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131014082251_rename_menu_id_to_offering_id_in_orders.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131014145210_add_note_to_orders.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131114102442_create_tour.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131114133742_create_customers_tours.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131120125138_create_addresses.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131120131030_add_address_id_to_customers.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131121104531_create_keys.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131125120034_create_users.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131216161434_add_state_to_order.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20131219101730_add_prefix_to_customer.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140119121741_add_roles_to_users.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140119224408_add_price_class_id_to_offering.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140123095956_add_customer_id_to_user.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140129151213_create_catchment_areas.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140129152023_add_catchment_area_id_to_customers.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140123131815_add_driver_id_to_tour.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140203221429_create_price_classes.rb')"
    self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20140205100144_add_telephone_number_to_customers.rb')"
  end
end
