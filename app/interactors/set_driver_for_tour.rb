require_relative "./base"

module Interactor
  class SetDriverForTour < Base
    register_boundary :user_gateway, -> { UserMapper.new }
    register_boundary :tour_gateway, -> { TourMapper.new }

    def run
      tour   = tour_gateway.find @request.tour_id
      driver = user_gateway.find @request.driver_id

      tour.driver = driver
      tour_gateway.update tour

      OpenStruct.new object: driver
    end
  end
end
