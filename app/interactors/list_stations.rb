module Interactor
  class ListStations
    attr_writer :tour_gateway, :order_gateway

    def initialize(tour_id, date)
      @tour_id = tour_id
      @date = date
    end

    def run
      tour = tour_gateway.find @tour_id
      orders_for_that_day = order_gateway.find_by_date(@date)
      muh = orders_for_that_day.select do |o|
        ## TODO use identity map
        tour.customers.map(&:id).include? o.customer.id
      end.map do |o|
        OpenStruct.new customer: o.customer, order: o
      end

      OpenStruct.new object: muh
    end

    private
      def tour_gateway
        @tour_gateway ||= TourMapper.new
      end

      def order_gateway
        @order_gateway ||= OrderMapper.new
      end
  end
end
