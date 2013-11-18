require_relative "./base"

module Interactor
  class CreateOffering < Base
    register_boundary :offering_gateway, -> { OfferingMapper.new }
    register_boundary :meal_gateway, -> { MealMapper.new }
    register_boundary :offering_source, -> { Offering.public_method(:new) }

    def initialize(date, meal_ids)
      @date = date
      @meal_ids = meal_ids
    end

    def run
      meals = @meal_ids.map { |id| meal_gateway.find(id) }
      offering = offering_source.call(date: @date, menu: OpenStruct.new(meals: meals))

      if offering.valid?
        offering_gateway.save offering
        OpenStruct.new object: offering
      else
        OpenStruct.new status: :invalid_request
      end
    end
  end
end
