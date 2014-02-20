require_relative "./base"

module Interactor
  class ListStations < Base
    register_boundary :tour_gateway,  -> { TourMapper.new }
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      tour = tour_gateway.find request.tour_id
      orders_for_that_day = order_gateway.find_by_date(request.date)
      muh = tour.customers.map do |c|
        orders_for_that_customer = orders_for_that_day.select { |o| o.customer.id == c.id }
        orders_for_that_customer.map do |o|
          OpenStruct.new customer: c, order: o
        end
      end.flatten

      OpenStruct.new object: muh
    end
  end
end
