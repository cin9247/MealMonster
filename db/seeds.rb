# encoding: utf-8

def create_customer(name)
  forename, surname = name.split(" ")
  Interactor::CreateCustomer.new(forename, surname).run.object
end

def create_customer_with_address_and_key(name, street_name, street_number, postal_code, town, key_name)
  forename, surname = name.split(" ")
  c = Interactor::CreateCustomer.new(forename, surname).run.object
  address = Interactor::AddAddressToCustomer.new(c.id, street_name, street_number, postal_code, town).run.object
  Interactor::AddKeyToAddress.new(address.id, key_name).run
  c
end

def create_offering(name, date, meal_ids)
  Interactor::CreateOffering.new(name, date, meal_ids, 1).run
end

def create_driver
  Interactor::CreateUser.new("driver", "driver").run.object
end

def create_admin
  Interactor::CreateUser.new("admin", "admin").run.object
end

DB[:meals].delete
DB[:menus].delete
DB[:meals_menus].delete
DB[:offerings].delete
DB[:customers].delete
DB[:addresses].delete
DB[:tours].delete
DB[:customers_tours].delete
DB[:orders].delete

rote_beete    = Interactor::CreateMeal.new("Rote Beete", 240, 0.4).run.object
gemüse_suppe  = Interactor::CreateMeal.new("Gemüsesuppe", 510, 1.2).run.object
spaghetti     = Interactor::CreateMeal.new("Spaghetti mit vegetarischer Bolognese", 1231, 3.5).run.object
würstchen     = Interactor::CreateMeal.new("Nürnberger Würstchen auf Sauerkraut", 1522, 4.2).run.object
erdbeer_quark = Interactor::CreateMeal.new("Erdbeerquark", 752, 1.5).run.object
bananen_quark = Interactor::CreateMeal.new("Bananenquark", 740, 1.6).run.object
obst_salat    = Interactor::CreateMeal.new("Obstsalat", 331, 0.2).run.object

today = Date.new(2013, 11, 11)

(today..(today + 2.days)).each do |d|
  create_offering("Menü #1", d, [rote_beete.id, würstchen.id, bananen_quark.id])
  create_offering("Menü #2", d, [rote_beete.id, spaghetti.id, erdbeer_quark.id])
  create_offering("Menü #3", d, [rote_beete.id, obst_salat.id])
end

((today + 3.days)..(today + 5.days)).each do |d|
  create_offering("Menü #1", d, [rote_beete.id, würstchen.id, bananen_quark.id])
  create_offering("Menü #2", d, [rote_beete.id, obst_salat.id])
end

c_1 = create_customer_with_address_and_key "Max Mustermann", "Rudolfstraße", "26", "76131", "Karlsruhe", "Schlüssel 1"
c_2 = create_customer_with_address_and_key "Peter Henkel", "Rudolfstraße", "3", "76131", "Karlsruhe", "Schlüssel 2"
c_3 = create_customer_with_address_and_key "Lemon Jello", "Wendtstraße", "7", "76185", "Karlsurhe", "Schlüssel 3"
c_4 = create_customer_with_address_and_key "John Lennon", "Schubertstraße", "5", "76147", "Karlsruhe", "Schlüssel 4"

offering_1 = Interactor::ListOfferings.new(today, today).run.object.first
offering_2 = Interactor::ListOfferings.new(today, today).run.object.last
Interactor::CreateOrder.new(c_1.id, offering_1.id).run
Interactor::CreateOrder.new(c_2.id, offering_2.id).run

Interactor::CreateTour.new("Tour #1", [c_1.id, c_2.id, c_3.id, c_4.id]).run
Interactor::CreateTour.new("Tour #2", [c_2.id, c_4.id]).run
Interactor::CreateTour.new("Tour #3", [c_1.id, c_2.id]).run
Interactor::CreateTour.new("Tour #4", [c_2.id] * 100).run

create_admin
create_driver
