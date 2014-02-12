module MenuHelper
  def meal_list(menu)
    menu.meals.map(&:name).join ", "
  end

  def menu_list(order)
    order.offerings.map { |o| o.menu.name }.join ", "
  end
end
