SPACE = -> React.DOM.span(null, " ")

CustomerRow = React.createClass
  edit_link: ->
    "/customers/#{@props.customer.id}/edit"

  detail_link: ->
    "/customers/#{@props.customer.id}"

  invoice_link: ->
    "/customers/#{@props.customer.id}/invoices"

  render: ->
    customer = @props.customer

    links = [
      React.DOM.a(href: @detail_link(), "Details")
      SPACE()
      React.DOM.a(href: @edit_link(), "Editieren")
      SPACE()
      React.DOM.a(href: @invoice_link(), "Abrechnung")
    ]

    React.DOM.tr(null, [
      React.DOM.td(null, customer.surname),
      React.DOM.td(null, customer.forename),
      React.DOM.td(null, customer.short_address),
      React.DOM.td(null, customer.catchment_area_name),
      React.DOM.td(null, links)
    ])

CustomerTable = React.createClass
  render: ->
    headerNames = ['Nachname', 'Vorname', 'Wohnort', 'Einzugsgebiet', 'Aktionen']
    headers = headerNames.map (n) -> React.DOM.td(null, n)

    customerRows = @props.customers.map (c) =>
      CustomerRow(customer: c)

    tableHead = React.DOM.thead(null, React.DOM.tr(null, headers))
    tableBody = React.DOM.tbody(null, customerRows)

    React.DOM.table(null, [tableHead, tableBody])

$ ->
  return unless $("#customers").length
  customers = $("#customers").data("customers")

  React.renderComponent(CareEAR.SearchableCustomerBox(customers: customers, tableWidth: 12, searchAttributes: ["surname"], customerTableView: CustomerTable), $("#customers")[0])
