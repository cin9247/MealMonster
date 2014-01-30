require_relative "./base"

module Interactor
  class RemoveDriverFromTour < Base
    register_boundary :tour_gateway, -> { TourMapper.new }

    def run
      tour = tour_gateway.find request.tour_id

      tour.eject_driver!

      tour_gateway.update tour

      OpenStruct.new success?: true, object: tour
    end
  end
end
