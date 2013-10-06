# encoding: utf-8

kitchen = Kitchen.new

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
  o_1 = d.new_offering menu: fleisch_menu
  o_2 = d.new_offering menu: vegi_menu
  o_3 = d.new_offering menu: spar_menu
  d.offer! o_1
  d.offer! o_2
  d.offer! o_3
end

kitchen.days((today + 3.days)..(today + 5.days)).each do |d|
  o_1 = d.new_offering menu: fleisch_menu
  o_2 = d.new_offering menu: spar_menu
  d.offer! o_1
  d.offer! o_2
end
