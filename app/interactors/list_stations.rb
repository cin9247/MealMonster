require_relative "./base"

module Interactor
  class ListStations < Base
    register_boundary :tour_gateway,  -> { TourMapper.new }
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      tour = tour_gateway.find_sparse request.tour_id
      stations = order_gateway.fetch_by_date_and_tour(request.date, request.tour_id).map do |o|
        OpenStruct.new customer: o.customer, order: o
      end

      muh = OpenStruct.new(date: request.date, stations: stations, name: tour.name, driver: tour.driver)

      OpenStruct.new object: muh
    end
  end
end
