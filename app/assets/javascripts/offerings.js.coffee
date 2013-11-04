$ ->
  createInput = (mealId, column, date) ->
    input = $("<input name='offerings[#{date}]menus[#{column}]meal_ids[]' type='hidden' value='#{mealId}'>")

  $("a.add-link").click ->
    column =   $(this).data("column")
    mealId =   $(this).data("meal-id")
    mealName = $(this).data("meal-name")

    date_divs = $("div[data-date]")
    date_divs.each (i, e) ->
      date = $(e).data("date")
      $(e).find(".menu.number#{column} .hidden-inputs").append createInput(mealId, parseInt(column), date)
      $(e).find(".menu.number#{column} .dropbox").append $("<li>#{mealName}</li>")
