# encoding: utf-8

def create_customer(name)
  forename, surname = name.split(" ")
  Interactor::CreateCustomer.new(forename, surname).run.object
end

def create_customer_with_address_and_key(name, town, postal_code, key_name)
  forename, surname = name.split(" ")
  c = Interactor::CreateCustomer.new(forename, surname).run.object
  address = Interactor::AddAddressToCustomer.new(c.id, "Heinestr.", "#{rand(20) + 1}", postal_code, town).run.object
  Interactor::AddKeyToAddress.new(address.id, key_name).run
  c
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
  Interactor::CreateOffering.new(d, [rote_beete.id, würstchen.id, bananen_quark.id]).run
  Interactor::CreateOffering.new(d, [rote_beete.id, spaghetti.id, erdbeer_quark.id]).run
  Interactor::CreateOffering.new(d, [rote_beete.id, obst_salat.id]).run
end

((today + 3.days)..(today + 5.days)).each do |d|
  Interactor::CreateOffering.new(d, [rote_beete.id, würstchen.id, bananen_quark.id]).run
  Interactor::CreateOffering.new(d, [rote_beete.id, obst_salat.id]).run
end

c_1 = create_customer_with_address_and_key "Max Mustermann", "Stuttgart", "71424", "Schlüssel 1"
c_2 = create_customer_with_address_and_key "Peter Henkel", "Karlsruhe", "76132", "Schlüssel 2"
c_3 = create_customer_with_address_and_key "Lemon Jello", "Karlsurhe", "76131", "Schlüssel 3"
c_4 = create_customer_with_address_and_key "John Lennon", "Karlsruhe", "76147", "Schlüssel 4"

offering_1 = Interactor::ListOfferings.new(today, today).run.object.first
offering_2 = Interactor::ListOfferings.new(today, today).run.object.last
Interactor::CreateOrder.new(c_1.id, offering_1.id).run
Interactor::CreateOrder.new(c_2.id, offering_2.id).run

Interactor::CreateTour.new("Tour #1", [c_1.id, c_2.id, c_3.id, c_4.id]).run
Interactor::CreateTour.new("Tour #2", [c_2.id, c_4.id]).run
Interactor::CreateTour.new("Tour #3", [c_1.id, c_2.id]).run
Interactor::CreateTour.new("Tour #4", [c_2.id] * 100).run
