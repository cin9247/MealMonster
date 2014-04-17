$ ->
  return unless $("#new-order-form").length

  customer_select = $("#customer_id")
  customer_list = customer_select.children()

  $("#catchment_area_id").change (event) ->
    catchment_area_id = parseInt($(this).val(), 10)

    if catchment_area_id
      filtered_customers = customer_list.filter ->
        $(this).data("catchment-area-id") == catchment_area_id
      customer_select.html(filtered_customers)
    else
      customer_select.html(customer_list)
