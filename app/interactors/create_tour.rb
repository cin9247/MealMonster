require_relative "./base"

module Interactor
  class CreateTour < Base
    register_boundary :customer_gateway, -> { CustomerMapper.new }
    register_boundary :tour_gateway,     -> { TourMapper.new }
    register_boundary :tour_source,      -> { Tour.public_method(:new) }

    def run
      customers = customer_gateway.find(request.customer_ids)
      tour = tour_source.call(customers: customers, name: request.name)

      if tour.valid?
        tour_gateway.save tour
        OpenStruct.new status: :successfully_created, object: tour
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
