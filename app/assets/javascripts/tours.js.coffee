SPACE = -> React.DOM.span(null, " ")

CustomerRow = React.createClass
  handleClick: (tourIndex, event) ->
    @props.addToTourHandler(tourIndex, @props.customer)
    event.preventDefault()

  render: ->
    links = [0...@props.tourCount].map (i) =>
      React.DOM.a({href: "#", onClick: @handleClick.bind(null, i)}, "##{i + 1} ")

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
    event.preventDefault()
    @props.removeCustomer(@props.customer)

  handleMoveUp: (event) ->
    event.preventDefault()
    @props.moveUp()

  handleMoveDown: (event) ->
    event.preventDefault()
    @props.moveDown()

  upLink: ->
    if @props.isFirst
      React.DOM.span(style: {color: "#ccc", "font-size": "1.5em"}, React.DOM.i(className: "fi-arrow-up"))
    else
      React.DOM.a({href: "#", style: {"font-size": "1.5em"}, onClick: @handleMoveUp},
        React.DOM.i(className: "fi-arrow-up"))

  downLink: ->
    if @props.isLast
      React.DOM.span(style: {color: "#ccc", "font-size": "1.5em"}, React.DOM.i(className: "fi-arrow-down"))
    else
      React.DOM.a({href: "#", style: {"font-size": "1.5em"}, onClick: @handleMoveDown}, React.DOM.i(className: "fi-arrow-down"))

  render: ->
    React.DOM.li({className: "station"}, [
      React.DOM.div(null, @props.customer.full_name)
      React.DOM.div(null, [
        @upLink()
        SPACE()
        @downLink()
        SPACE()
        React.DOM.a({className: "remove", href: "#", onClick: @handleRemove}, React.DOM.i(className: "fi-trash", style: {"font-size": "1.5em"}))
      ])
    ])

EditableHeader = React.createClass
  getInitialState: ->
    {editing: false}

  changeEditState: (event) ->
    event.preventDefault()
    @setState {editing: !@state.editing}

  updateContent: (event) ->
    event.preventDefault()
    @props.updateContent(event.target.value)

  removeTour: (event) ->
    event.preventDefault()
    if confirm("Wollen Sie die Tour \"#{@props.content}\" wirklich löschen?")
      @props.removeTour()

  render: ->
    inner = if !@state.editing
      [
        React.DOM.h3(className: "header", onDoubleClick: @changeEditState, @props.content),
        React.DOM.div(className: "inplace-edit",
          React.DOM.a(href: "#", onClick: @changeEditState, "Name editieren")
          SPACE()
          React.DOM.a(href: "#", onClick: @removeTour, "Tour löschen")
        )
      ]
    else
      [
        React.DOM.input({value: @props.content, onChange: @updateContent}),
        React.DOM.a({href: "#", onClick: @changeEditState}, "Fertig")
      ]

    React.DOM.div({className: "tour-header"}, inner)

NO_DRIVER = "no-driver"
TourWidget = React.createClass
  driverChanged: (event) ->
    if event.target.value == NO_DRIVER
      @props.removeDriver()
    else
      @props.setDriver(parseInt(event.target.value))

  render: ->
    customerList = @props.tour.customers.map (c, i) =>
      isFirst = (i == 0)
      isLast = (i == @props.tour.customers.length - 1)
      CustomerInTour({customer: c, isFirst: isFirst, isLast: isLast, removeCustomer: @props.removeCustomer, moveUp: @props.moveUp.bind(null, c, i), moveDown: @props.moveDown.bind(null, c, i)}, position: i)

    driverList = [React.DOM.option(value: NO_DRIVER, "(Kein Fahrer)")]

    @props.drivers.forEach (d) =>
      driverList.push React.DOM.option(value: d.id, d.name)

    selectedValue = if @props.tour.driver then @props.tour.driver.id else NO_DRIVER

    React.DOM.li({className: "tour"}, [
      React.DOM.h5(className: "subheader", "Tour ##{@props.tourIndex + 1}"),
      EditableHeader({content: @props.tour.name, updateContent: @props.updateName, removeTour: @props.removeTour})
      React.DOM.div(className: "driver-select", [
        React.DOM.label({htmlFor: "tour-#{@props.tour.id}"}, "Fahrer")
        React.DOM.select({value: selectedValue, id: "tour-#{@props.tour.id}", onChange: @driverChanged}, driverList)
      ])
      React.DOM.ul(null, customerList)
    ])

DirtyWidget = React.createClass
  render: ->
    if @props.dirtyState.saving
      React.DOM.div(className: "alert-box secondary", "Änderungen werden gespeichert.")
    else if @props.dirtyState.saved
      React.DOM.div(className: "alert-box success", "Erfolgreich gespeichert.")
    else if @props.dirtyState.error
      React.DOM.div(className: "alert-box alert", "Es gab einen Fehler beim Speichern ihrer Touren.")
    else if @props.dirtyState.modified
      React.DOM.div(className: "alert-box secondary", "Achtung! Ein paar Änderungen sind noch nicht gespeichert worden.")
    else
      React.DOM.div(null, "")

ToursWidget = React.createClass
  render: ->
    tourWidgets = @props.tours.map (t, i) =>
      TourWidget({columnWidth: parseInt(12 / @props.tours.length, 10), tour: t, tourIndex: i, updateName: @props.updateName.bind(null, t), removeTour: @props.removeTour.bind(null, t, i), removeCustomer: @props.removeCustomerFromTour.bind(null, t), moveUp: @props.moveUp.bind(null, t), moveDown: @props.moveDown.bind(null, t), drivers: @props.drivers, setDriver: @props.setDriver.bind(null, t), removeDriver: @props.removeDriver.bind(null, t)})

    React.DOM.ul({className: "large-block-grid-3 tours"}, tourWidgets)

ManageTourWidget = React.createClass
  getInitialState: ->
    {
      customers: @props.customers
      tours: @props.tours
      dirtyState: {modified: false, saving: false, saved: false, error: false}
    }

  addCustomerToTour: (customer, tour) ->
    tour.customers.push customer

  removeCustomerFromTour: (tour, customer) ->
    customerIndex = tour.customers.indexOf customer
    if customerIndex > -1
      tour.customers.splice(customerIndex, 1)
    @pushState()

  addTour: (event) ->
    event.preventDefault()
    @state.tours.push {id: null, name: "Tour ##{@state.tours.length + 1}", customers: [], driver: null}
    @pushState()

  removeTour: (tour, tourIndex) ->
    @state.tours.splice(tourIndex, 1)
    @pushState()

  addToTourHandler: (tourIndex, customer) ->
    ## modify stuff in place
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
    @updateDirtyState("saved", false)
    @updateDirtyState("modified", true)
    @setState(@state)

  updateName: (tour, name) ->
    tour.name = name
    @pushState()

  moveUp: (tour, customer, oldPosition) ->
    return if oldPosition == 0

    upperCustomer = tour.customers[oldPosition - 1]
    tour.customers[oldPosition - 1] = customer
    tour.customers[oldPosition] = upperCustomer
    @pushState()

  moveDown: (tour, customer, oldPosition) ->
    return if tour.customers.length - 1 == oldPosition

    lowerCustomer = tour.customers[oldPosition + 1]
    tour.customers[oldPosition + 1] = customer
    tour.customers[oldPosition] = lowerCustomer
    @pushState()

  setDriver: (tour, driverId) ->
    foundDriver = null
    @props.drivers.forEach (d) ->
      if d.id == driverId
        foundDriver = d
    tour.driver = foundDriver

    @pushState()

  removeDriver: (tour) ->
    delete tour.driver

    @pushState()

  render: ->
    React.DOM.div(null, [
      CustomerTable({customers: @state.customers, addToTourHandler: @addToTourHandler, tourCount: @state.tours.length})

      React.DOM.div(className: "row", [
        React.DOM.div({className: "columns large-3"}, [
          React.DOM.button({onClick: @submit}, "Speichern")
        ])
        React.DOM.div({className: "columns large-9"}, DirtyWidget(dirtyState: @state.dirtyState))
      ])

      ToursWidget({updateName: @updateName, tours: @state.tours, removeTour: @removeTour, removeCustomerFromTour: @removeCustomerFromTour, drivers: @props.drivers, setDriver: @setDriver, removeDriver: @removeDriver, moveUp: @moveUp, moveDown: @moveDown})
      React.DOM.button({className: "tiny secondary", onClick: @addTour, href: "/tours/new"}, "Neue Tour erstellen")
    ])

$ ->
  return unless $("#manage-tours").length

  customers = $("#manage-tours").data("customers")
  tours = $("#manage-tours").data("tours")
  drivers = $("#manage-tours").data("drivers")

  React.renderComponent(ManageTourWidget(customers: customers, tours: tours, drivers: drivers), $("#manage-tours")[0])

  ##TODO let TourWidget handle removing and shit, but send callback "new tour list" back to parent which then saves this in order to push it to the server
