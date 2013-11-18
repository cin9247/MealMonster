require_relative "./base"

module Interactor
  class ListTours < Base
    attr_writer :tour_gateway

    def initialize(date)
      @date = date
    end

    def run
      OpenStruct.new object: tour_gateway.fetch
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
