require "ostruct"

module NavigationHelper
  def navigation_items
    [
      OpenStruct.new(title: "Startseite", url: root_path, active: controller?("main")),
      OpenStruct.new(title: "Kunden", url: customers_path, active: controller?("customers")),
      OpenStruct.new(title: "Angebotene Menus", url: offerings_path, active: controller?("offerings")),
      OpenStruct.new(title: "Gerichte", url: meals_path, active: controller?("meals")),
      OpenStruct.new(title: "Bestellungen", url: orders_path, active: controller?("orders")),
      OpenStruct.new(title: "Touren", url: tours_path, active: controller?("tours")),
      OpenStruct.new(title: "Tickets", url: tickets_path, active: controller?("tickets")),
      (OpenStruct.new(title: "Adminbereich", url: admins_path, active: controller?("admins")) if current_user.has_role?(:admin) || current_user.has_role?(:manager))
    ].compact
  end

  def controller?(*names)
    names.include? params[:controller]
  end
end
