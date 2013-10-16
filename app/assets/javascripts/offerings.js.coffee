$ ->
  createInput = (mealId, column) ->
    input = $("<input name='offerings[2013-10-03]menus[#{column}]meal_ids[]' type='hidden' value='#{mealId}'>")

  $("a.add-link").click ->
    column =   $(this).data("column")
    mealId =   $(this).data("meal-id")
    mealName = $(this).data("meal-name")
    $(".menu.number#{column} .hidden-inputs").append createInput(mealId, parseInt(column))
    $(".menu.number#{column} .dropbox").append $("<li>#{mealName}</li>")
