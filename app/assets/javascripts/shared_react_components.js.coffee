CareEAR.SearchBox = React.createClass
  onChange: (event) ->
    @props.onSearch event.target.value

  render: ->
    React.DOM.form(null,
      React.DOM.div(className: "row collapse", [
        React.DOM.div(className: "small-3 large-2 columns",
          React.DOM.span(className: "prefix", React.DOM.i(className: "fi-magnifying-glass"))
        )
        React.DOM.div(className: "small-9 large-10 columns",
          React.DOM.input(type: "text", placeholder: "Kunden filtern...", onChange: @onChange)
        )]
      )
    )

CareEAR.SearchableCustomerBox = React.createClass
  getInitialState: ->
    {}

  filterCustomers: (searchText) ->
    filteredCustomers = @props.customers.filter (customer) =>
      regex = new RegExp searchText, "i"
      !!regex.test(customer[@props.searchAttributes[0]])

    @setState(customers: filteredCustomers)

  render: ->
    React.DOM.div(className: "customer-search-box",
      React.DOM.div(className: "row",
        React.DOM.div(className: "large-4 small-12 columns",
          CareEAR.SearchBox(onSearch: @filterCustomers)
        )
      )
      React.DOM.div(className: "row",
        React.DOM.div(className: "customers large-#{@props.tableWidth} small-12 columns",
          @props.customerTableView({customers: @state.customers || @props.customers, addToTourHandler: @props.addToTourHandler, tourCount: @props.tourCount})
        )
      )
    )
