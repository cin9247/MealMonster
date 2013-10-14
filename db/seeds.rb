# encoding: utf-8

organization = Organization.new
kitchen = organization.kitchen

rote_beete    = kitchen.new_meal name: "Rote Beete", kilojoules: 240, bread_units: 0.4
gemüse_suppe  = kitchen.new_meal name: "Gemüsesuppe", kilojoules: 510, bread_units: 1.2
spaghetti     = kitchen.new_meal name: "Spaghetti mit vegetarischer Bolognese", kilojoules: 1231, bread_units: 3.5
würstchen     = kitchen.new_meal name: "Nürnberger Würstchen auf Sauerkraut", kilojoules: 1522, bread_units: 4.2
erdbeer_quark = kitchen.new_meal name: "Erdbeerquark", kilojoules: 752, bread_units: 1.5
bananen_quark = kitchen.new_meal name: "Bananenquark", kilojoules: 740, bread_units: 1.6
obst_salat    = kitchen.new_meal name: "Obstsalat", kilojoules: 331, bread_units: 0.2

fleisch_menu  = kitchen.new_menu meals: [rote_beete, würstchen, bananen_quark]
vegi_menu     = kitchen.new_menu meals: [rote_beete, spaghetti, erdbeer_quark]
spar_menu     = kitchen.new_menu meals: [rote_beete, obst_salat]

today = Date.today

organization.days(today..(today + 2.days)).each do |d|
  d.offer! fleisch_menu
  d.offer! vegi_menu
  d.offer! spar_menu
end

organization.days((today + 3.days)..(today + 5.days)).each do |d|
  d.offer! fleisch_menu
  d.offer! spar_menu
end

c_1 = organization.new_customer forename: "Max", surname: "Mustermann"
c_2 = organization.new_customer forename: "Peter", surname: "Henkel"

c_1.subscribe!
c_2.subscribe!

offering = organization.day(today).offerings.find { |o| o.menu.id == vegi_menu.id }
order = organization.day(today).new_order customer: c_1, offering: offering
order.place!
