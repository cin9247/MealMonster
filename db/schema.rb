Sequel.migration do
  change do
    create_table(:customers) do
      primary_key :id
      column :forename, "text"
      column :surname, "text"
    end

    create_table(:customers_tours) do
      primary_key :id
      column :customer_id, "integer", :null=>false
      column :tour_id, "integer", :null=>false
      column :position, "integer", :null=>false
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
    end

    create_table(:orders) do
      primary_key :id
      column :offering_id, "integer", :null=>false
      column :customer_id, "integer", :null=>false
      column :date, "date", :null=>false
      column :note, "text"
    end

    create_table(:schema_migrations) do
      column :filename, "text", :null=>false

      primary_key [:filename]
    end

    create_table(:tours) do
      primary_key :id
      column :name, "text", :null=>false
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
  end
end
