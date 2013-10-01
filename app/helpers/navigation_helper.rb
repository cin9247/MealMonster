require "ostruct"

module NavigationHelper
  def navigation_items
    [
      OpenStruct.new(title: "Dashboard", url: root_path, active: true),
      OpenStruct.new(title: "Kunden", url: root_path),
      OpenStruct.new(title: "Menus", url: menus_path),
      OpenStruct.new(title: "Gerichte", url: meals_path),
      OpenStruct.new(title: "Touren", url: tours_path)
    ]
  end
end
