$ ->
  return unless $("#new-offering").length

  ## TODO connect to sortable

  $("li.meal").draggable
    cursor: "pointer"
    helper: "clone"
    revert: true

  $("ol.dropbox").droppable
    drop: (e, ui) ->
      date = $(this).data "date"
      column = $(this).data "column"
      mealId = $(ui.draggable).data "meal-id"
      mealName = $(ui.draggable).data "meal-name"

      inputTag = $(buildInputTag date, column, mealId)

      elementWithInput = $(ui.draggable).prepend(inputTag)

      $(this).append elementWithInput

  buildInputTag = (date, column, mealId) ->
    "<input name='offerings[#{date}]menus[#{column}]meal_ids[]' type='hidden' value='#{mealId}'>"
