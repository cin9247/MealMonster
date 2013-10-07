Sequel.migration do
  change do
    create_table(:customers) do
      primary_key :id
      column :forename, "text"
      column :surname, "text"
    end

    create_table(:meals) do
      primary_key :id
      column :name, "text", :null=>false
    end

    create_table(:meals_menus) do
      primary_key :id
      column :menu_id, "integer", :null=>false
      column :meal_id, "integer", :null=>false
      column :position, "integer", :null=>false
    end

    create_table(:menus) do
      primary_key :id
    end

    create_table(:offerings) do
      primary_key :id
      column :date, "date", :null=>false
      column :menu_id, "integer", :null=>false
    end

    create_table(:schema_migrations) do
      column :filename, "text", :null=>false

      primary_key [:filename]
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
  end
end
