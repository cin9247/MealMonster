require "ostruct"

module NavigationHelper
  def navigation_items
    [
      OpenStruct.new(title: "Dashboard", url: root_path, active: controller?("main")),
      OpenStruct.new(title: "Kunden", url: customers_path, active: controller?("customers")),
      OpenStruct.new(title: "Angebotene Menus", url: offerings_path, active: controller?("offerings")),
      OpenStruct.new(title: "Gerichte", url: meals_path, active: controller?("meals")),
      OpenStruct.new(title: "Bestellungen", url: orders_path, active: controller?("orders")),
      OpenStruct.new(title: "Touren", url: tours_path, active: controller?("tours"))
    ]
  end

  def controller?(*names)
    names.include? params[:controller]
  end
end
