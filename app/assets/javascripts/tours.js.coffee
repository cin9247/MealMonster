CustomerRow = React.createClass
  handleClick: (tourIndex, event) ->
    @props.addToTourHandler(tourIndex, @props.customer)
    event.preventDefault()

  render: ->
    links = [0...@props.tourCount].map (i) =>
      React.DOM.a({href: "#", onClick: @handleClick.bind(@, i)}, "##{i + 1} ")

    customer = @props.customer
    React.DOM.tr(null, [
      React.DOM.td(null, customer.full_name),
      React.DOM.td(null, customer.short_address),
      React.DOM.td(null, links)
    ])

CustomerTable = React.createClass
  render: ->
    if @props.customers.length == 0
      return React.DOM.div(className: "panel callout", "Alle Kunden wurden erfolgreich zugeordnet.")
    headers = [React.DOM.td(null, 'Name'), React.DOM.td(null, 'Adresse'), React.DOM.td(null, "Zu Tour hinzufügen")]

    customerRows = @props.customers.map (c) =>
      CustomerRow({customer: c, addToTourHandler: @props.addToTourHandler, tourCount: @props.tourCount})
    tableHead = React.DOM.thead(null, React.DOM.tr(null, headers))
    tableBody = React.DOM.tbody(null, customerRows)

    React.DOM.table(null, [tableHead, tableBody])

CustomerInTour = React.createClass
  render: ->
    React.DOM.li(null, @props.customer.full_name)

TourWidget = React.createClass
  render: ->
    customerList = @props.tour.customers.map (c) ->
      CustomerInTour({customer: c})

    React.DOM.li({className: "tour columns large-#{@props.columnWidth}"}, [
      React.DOM.h2(null, @props.tour.name),
      React.DOM.ul(null, customerList)
    ])

ToursWidget = React.createClass
  render: ->
    tourWidgets = @props.tours.map (t) =>
      TourWidget({columnWidth: 12 / @props.tours.length, tour: t})

    React.DOM.ul({className: "row"}, tourWidgets)

ManageTourWidget = React.createClass
  getInitialState: ->
    {
      customers: @props.customers,
      tours: @props.tours
    }

  ## TODO set visible flag instead of removing it
  removeCustomer: (customer) ->
    customerIndex = @state.customers.indexOf(customer)
    if customerIndex > -1
      @state.customers.splice(customerIndex, 1)

  addCustomerToTour: (customer, tour) ->
    tour.customers.push customer

  addToTourHandler: (tourIndex, customer) ->
    ## modify stuff in place
    @removeCustomer customer
    @addCustomerToTour customer, @state.tours[tourIndex]
    ## trigger update
    @setState({customers: @state.customers, tours: @state.tours})

  submit: ->
    $.ajax "/tours",
      type: "PUT"
      data: {tours: @state.tours}

  render: ->
    React.DOM.div(null, [
      CustomerTable({customers: @state.customers, addToTourHandler: @addToTourHandler, tourCount: @state.tours.length}),
      ToursWidget({tours: @state.tours}),
      React.DOM.a({onClick: @addTour, href: "/tours/new"}, "Neue Tour erstellen")
      React.DOM.button({onClick: @submit}, "Speichern")
    ])

$ ->
  return unless $("#manage-tours").length

  customers = $("#manage-tours").data("customers")
  tours = $("#manage-tours").data("tours")

  React.renderComponent(ManageTourWidget(customers: customers, tours: tours), $("#manage-tours")[0])
