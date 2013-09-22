require "ostruct"

module ApplicationHelper
  def navigation_items
    [
      OpenStruct.new(title: "Dashboard", url: root_path, active: true),
      OpenStruct.new(title: "Kunden", url: root_path),
      OpenStruct.new(title: "Menus", url: root_path),
      OpenStruct.new(title: "Touren", url: root_path),
      OpenStruct.new(title: "Lager", url: root_path)
    ]
  end
end
