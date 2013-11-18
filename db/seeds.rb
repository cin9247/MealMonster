# encoding: utf-8

def create_customer(name)
  forename, surname = name.split(" ")
  c = Organization.new.new_customer forename: forename, surname: surname
  Interactor::CreateCustomer.new(c).run
  c
end

DB[:meals].delete
DB[:menus].delete
DB[:meals_menus].delete
DB[:offerings].delete
DB[:customers].delete
DB[:tours].delete
DB[:customers_tours].delete
DB[:orders].delete

kitchen = Organization.new.kitchen

rote_beete    = kitchen.new_meal name: "Rote Beete", kilojoules: 240, bread_units: 0.4
gemüse_suppe  = kitchen.new_meal name: "Gemüsesuppe", kilojoules: 510, bread_units: 1.2
spaghetti     = kitchen.new_meal name: "Spaghetti mit vegetarischer Bolognese", kilojoules: 1231, bread_units: 3.5
würstchen     = kitchen.new_meal name: "Nürnberger Würstchen auf Sauerkraut", kilojoules: 1522, bread_units: 4.2
erdbeer_quark = kitchen.new_meal name: "Erdbeerquark", kilojoules: 752, bread_units: 1.5
bananen_quark = kitchen.new_meal name: "Bananenquark", kilojoules: 740, bread_units: 1.6
obst_salat    = kitchen.new_meal name: "Obstsalat", kilojoules: 331, bread_units: 0.2

Interactor::CreateMeal.new(rote_beete).run
Interactor::CreateMeal.new(gemüse_suppe).run
Interactor::CreateMeal.new(spaghetti).run
Interactor::CreateMeal.new(würstchen).run
Interactor::CreateMeal.new(erdbeer_quark).run
Interactor::CreateMeal.new(bananen_quark).run
Interactor::CreateMeal.new(obst_salat).run

fleisch_menu  = kitchen.new_menu meals: [rote_beete, würstchen, bananen_quark]
vegi_menu     = kitchen.new_menu meals: [rote_beete, spaghetti, erdbeer_quark]
spar_menu     = kitchen.new_menu meals: [rote_beete, obst_salat]

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

c_1 = create_customer "Max Mustermann"
c_2 = create_customer "Peter Henkel"
c_3 = create_customer "Lemon Jello"
c_4 = create_customer "John Lennon"

offering_1 = Interactor::ListOfferings.new(today, today).run.object.first
offering_2 = Interactor::ListOfferings.new(today, today).run.object.last
Interactor::CreateOrder.new(c_1.id, offering_1.id).run
Interactor::CreateOrder.new(c_2.id, offering_2.id).run

Interactor::CreateTour.new("Tour #1", [c_1.id, c_2.id, c_3.id, c_4.id]).run
Interactor::CreateTour.new("Tour #2", [c_2.id, c_4.id]).run
Interactor::CreateTour.new("Tour #3", [c_1.id, c_2.id]).run
Interactor::CreateTour.new("Tour #4", [c_2.id] * 100).run
