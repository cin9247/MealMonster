# encoding: utf-8

def create_customer(name)
  forename, surname = name.split(" ")
  Interactor::CreateCustomer.new(forename, surname).run.object
end

def create_order(customer_id, offering_id)
  request = OpenStruct.new(customer_id: customer_id, offering_id: offering_id)
  Interactor::CreateOrder.new(request).run.object
end

def create_customer_with_address_and_key(name, street_name, street_number, postal_code, town, key_name)
  forename, surname = name.split(" ")
  request = OpenStruct.new(forename: forename, surname: surname)
  c = Interactor::CreateCustomer.new(request).run.object
  request = OpenStruct.new(customer_id: c.id, street_name: street_name, street_number: street_number, postal_code: postal_code, town: town)
  address = Interactor::AddAddressToCustomer.new(request).run.object
  request = OpenStruct.new(address_id: address.id, name: key_name)
  Interactor::AddKeyToAddress.new(request).run
  c
end

def create_offering(name, date, meal_ids)
  request = OpenStruct.new(name: name, date: date, meal_ids: meal_ids, price_class_id: 1)
  Interactor::CreateOffering.new(request).run.object
end

def create_user(name, password, role)
  request = OpenStruct.new(name: name, password: name)
  user = Interactor::RegisterUser.new(request).run.object
  request = OpenStruct.new(user_id: user.id, role: role)
  Interactor::SetRole.new(request).run
  user
end

def create_driver
  create_user "driver", "driver", "driver"
end

def create_admin
  create_user "admin", "admin", "admin"
end

def create_meal(name, kilojoules, bread_units)
  request = OpenStruct.new(name: name, kilojoules: kilojoules, bread_units: bread_units)
  Interactor::CreateMeal.new(request).run.object
end

def create_tour(name, customer_ids)
  request = OpenStruct.new(name: name, customer_ids: customer_ids)
  Interactor::CreateTour.new(request).run.object
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
DB[:users].delete

rote_beete    = create_meal("Rote Beete", 240, 0.4)
gemüse_suppe  = create_meal("Gemüsesuppe", 510, 1.2)
spaghetti     = create_meal("Spaghetti mit vegetarischer Bolognese", 1231, 3.5)
würstchen     = create_meal("Nürnberger Würstchen auf Sauerkraut", 1522, 4.2)
erdbeer_quark = create_meal("Erdbeerquark", 752, 1.5)
bananen_quark = create_meal("Bananenquark", 740, 1.6)
obst_salat    = create_meal("Obstsalat", 331, 0.2)

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

request = OpenStruct.new(from: today, to: today)
offering_1 = Interactor::ListOfferings.new(request).run.object.first
offering_2 = Interactor::ListOfferings.new(request).run.object.last
create_order(c_1.id, offering_1.id)
create_order(c_2.id, offering_2.id)

create_tour("Tour #1", [c_1.id, c_2.id, c_3.id, c_4.id])
create_tour("Tour #2", [c_2.id, c_4.id])
create_tour("Tour #3", [c_1.id, c_2.id])
create_tour("Tour #4", [c_2.id])

create_admin
create_driver
