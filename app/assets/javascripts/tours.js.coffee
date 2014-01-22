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

    React.DOM.table(className: "customers", [tableHead, tableBody])

CustomerInTour = React.createClass
  handleRemove: (event) ->
    @props.removeCustomer(@props.customer)
    event.preventDefault()

  render: ->
    React.DOM.li(null, [React.DOM.span(null, @props.customer.full_name), React.DOM.a({href: "#", onClick: @handleRemove}, ' X')])

TourWidget = React.createClass
  render: ->
    customerList = @props.tour.customers.map (c) =>
      CustomerInTour({customer: c, removeCustomer: @props.removeCustomer})

    React.DOM.li({className: "tour columns large-#{@props.columnWidth}"}, [
      React.DOM.h2(null, @props.tour.name),
      React.DOM.ul(null, customerList)
    ])

DirtyWidget = React.createClass
  render: ->
    if @props.dirtyState.saving
      React.DOM.div(className: "alert-box secondary", "We're busy saving your changes")
    else if @props.dirtyState.saved
      React.DOM.div(className: "alert-box success", "Successfully saved")
    else if @props.dirtyState.error
      React.DOM.div(className: "alert-box alert", "There was an error saving your changes")
    else if @props.dirtyState.modified
      React.DOM.div(className: "alert-box secondary", "You have unsaved changes")
    else
      React.DOM.div(null, "")

ToursWidget = React.createClass
  render: ->
    tourWidgets = @props.tours.map (t, i) =>
      console.log i
      TourWidget({columnWidth: 12 / @props.tours.length, tour: t, removeCustomer: @props.removeCustomerFromTour.bind(@, t)})

    React.DOM.ul({className: "row tours"}, tourWidgets)

ManageTourWidget = React.createClass
  getInitialState: ->
    {
      customers: @props.customers
      tours: @props.tours
      dirtyState: {modified: false, saving: false, saved: false, error: false}
    }

  ## TODO set visible flag instead of removing it
  removeCustomer: (customer) ->
    customerIndex = @state.customers.indexOf(customer)
    if customerIndex > -1
      @state.customers.splice(customerIndex, 1)

  addCustomerToTour: (customer, tour) ->
    tour.customers.push customer

  removeCustomerFromTour: (tour, customer) ->
    customerIndex = tour.customers.indexOf customer
    if customerIndex > -1
      tour.customers.splice(customerIndex, 1)
    @pushState()
    @updateDirtyState("saved", false)
    @updateDirtyState("modified", true)

  addToTourHandler: (tourIndex, customer) ->
    ## modify stuff in place
    @removeCustomer customer
    @addCustomerToTour customer, @state.tours[tourIndex]
    ## trigger update
    @pushState()
    @updateDirtyState("modified", true)
    @updateDirtyState("saved", false)

  submit: ->
    @updateDirtyState("saving", true)
    @updateDirtyState("saved", false)
    $.ajax("/tours",
      type: "PUT"
      data: {tours: @state.tours}
    ).then(=>
      console.log "saved"
      @updateDirtyState("saved", true)
      @updateDirtyState("saving", false)
      @updateDirtyState("modified", false)
    , =>
      @updateDirtyState("saving", false)
      @updateDirtyState("error", true)
    )

  updateDirtyState: (property, value) ->
    @state.dirtyState[property] = value
    @setState(@state)

  pushState: ->
    @setState(@state)

  render: ->
    React.DOM.div(null, [
      CustomerTable({customers: @state.customers, addToTourHandler: @addToTourHandler, tourCount: @state.tours.length})

      React.DOM.div(className: "row", [
        React.DOM.div({className: "columns large-3"}, [
          React.DOM.button({onClick: @submit}, "Speichern")
        ])
        React.DOM.div({className: "columns large-9"}, DirtyWidget(dirtyState: @state.dirtyState))
      ])

      ToursWidget({tours: @state.tours, removeCustomerFromTour: @removeCustomerFromTour})
      React.DOM.a({onClick: @addTour, href: "/tours/new"}, "Neue Tour erstellen")
    ])

$ ->
  return unless $("#manage-tours").length

  customers = $("#manage-tours").data("customers")
  tours = $("#manage-tours").data("tours")

  React.renderComponent(ManageTourWidget(customers: customers, tours: tours), $("#manage-tours")[0])

  ##TODO let TourWidget handle removing and shit, but send callback "new tour list" back to parent which then saves this in order to push it to the server
