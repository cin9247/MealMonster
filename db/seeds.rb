# encoding: utf-8

organization = Organization.new
kitchen = organization.kitchen

rote_beete    = kitchen.new_meal name: "Rote Beete"
gemüse_suppe  = kitchen.new_meal name: "Gemüsesuppe"
spaghetti     = kitchen.new_meal name: "Spaghetti mit vegetarischer Bolognese"
würstchen     = kitchen.new_meal name: "Nürnberger Würstchen auf Sauerkraut"
erdbeer_quark = kitchen.new_meal name: "Erdbeerquark"
bananen_quark = kitchen.new_meal name: "Bananenquark"
obst_salat    = kitchen.new_meal name: "Obstsalat"

fleisch_menu  = kitchen.new_menu meals: [rote_beete, würstchen, bananen_quark]
vegi_menu     = kitchen.new_menu meals: [rote_beete, spaghetti, erdbeer_quark]
spar_menu     = kitchen.new_menu meals: [rote_beete, obst_salat]

today = Date.today

kitchen.days(today..(today + 2.days)).each do |d|
  d.offer! fleisch_menu
  d.offer! vegi_menu
  d.offer! spar_menu
end

kitchen.days((today + 3.days)..(today + 5.days)).each do |d|
  d.offer! fleisch_menu
  d.offer! spar_menu
end

c_1 = organization.new_customer forename: "Max", surname: "Mustermann"
c_2 = organization.new_customer forename: "Peter", surname: "Henkel"

c_1.subscribe!
c_2.subscribe!
