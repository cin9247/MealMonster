require "ostruct"

module NavigationHelper
  def navigation_items
    [
      OpenStruct.new(title: "Dashboard", url: root_path, active: controller?("main")),
      OpenStruct.new(title: "Kunden", url: customers_path, active: controller?("customers")),
      OpenStruct.new(title: "Angebotene Menus", url: menus_path, active: controller?("menus")),
      OpenStruct.new(title: "Gerichte", url: meals_path, active: controller?("meals")),
      OpenStruct.new(title: "Touren", url: tours_path, active: controller?("tours"))
    ]
  end

  def controller?(*names)
    names.include? params[:controller]
  end
end
