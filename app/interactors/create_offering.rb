require_relative "./base"

module Interactor
  class CreateOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :meal_gateway, -> { MealMapper.new }
    register_boundary :offering_source, -> { Offering.public_method(:new) }

    def run
      meals = request.meal_ids.map { |id| meal_gateway.find(id) }
      offering = offering_source.call(date: request.date, menu: OpenStruct.new(meals: meals, name: request.name))

      if offering.valid?
        offering_gateway.save offering
        OpenStruct.new object: offering
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
