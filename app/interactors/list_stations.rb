require_relative "./base"

module Interactor
  class ListStations < Base
    register_boundary :order_gateway, -> { OrderMapper.new }

    def run
      stations = order_gateway.fetch_by_date_and_tour(request.date, request.tour_id).map do |o|
        OpenStruct.new customer: o.customer, order: o
      end

      muh = OpenStruct.new(date: request.date, stations: stations)

      OpenStruct.new object: muh
    end
  end
end
