module Interactor
  class CreateTour
    attr_writer :customer_gateway, :tour_gateway
    attr_writer :tour_source

    def initialize(name, customer_ids)
      @name         = name
      @customer_ids = customer_ids
    end

    def run
      customers = customer_gateway.find(@customer_ids)
      tour = tour_source.call(customers: customers, name: @name)

      if tour.valid?
        tour_gateway.save tour
        OpenStruct.new status: :successfully_created
      else
        OpenStruct.new status: :invalid_request
      end
    end

    private
      def customer_gateway
        @customer_gateway ||= CustomerMapper.new
      end

      def tour_gateway
        @tour_gateway ||= TourMapper.new
      end

      def tour_source
        @tour_source ||= Tour.public_method(:new)
      end
  end
end