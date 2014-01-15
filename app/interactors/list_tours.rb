require_relative "./base"

module Interactor
  class ListTours < Base
    register_boundary :tour_gateway, -> { TourMapper.new }

    def run
      OpenStruct.new object: tour_gateway.fetch
    end
  end
end
