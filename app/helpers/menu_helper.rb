module MenuHelper
  def meal_list(menu)
    menu.meals.map(&:name).join ", "
  end
end
