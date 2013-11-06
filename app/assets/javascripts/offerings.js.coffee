$ ->
  $(".draggable").draggable
    cursorAt:
      bottom: 0
  $("ol.dropbox").droppable
    drop: (e, ui) ->
      date = $(this).data "date"
      column = $(this).data "column"
      mealId = $(ui.draggable).data "meal-id"
      mealName = $(ui.draggable).data "meal-name"
      inputTag = buildInputTag date, column, mealId

      $(this).append $("<li class='meal'>#{mealName}#{inputTag}</li>")

  buildInputTag = (date, column, mealId) ->
    "<input name='offerings[#{date}]menus[#{column}]meal_ids[]' type='hidden' value='#{mealId}'>"
